import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/order.dart';
import 'package:fractal_challenge/services/http_service.dart';
import 'package:fractal_challenge/utils/snackbar_message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fractal_challenge/models/product.dart';
import 'package:fractal_challenge/models/order.dart';

class AddEditOrderScreen extends StatefulWidget {
  const AddEditOrderScreen({super.key});

  @override
  State<AddEditOrderScreen> createState() => _AddEditOrderScreenState();
}

class _AddEditOrderScreenState extends State<AddEditOrderScreen> {
  int? idOrder;
  TextEditingController numberOrderController = TextEditingController();
  TextEditingController dateOrderController = TextEditingController();
  TextEditingController numberProductsController = TextEditingController();
  TextEditingController finalPriceController = TextEditingController();

  String titleModule = "Add";
  List<Product> products = [];
  Map<int, int> productsToOrder = {}; //{productId, quantity}
  List<OrderDetail> orderDetails = [];
  Order? _orderFound;

  HttpService httpService = Get.find<HttpService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProducts();
    idOrder = (Get.parameters['id'] !=null && int.parse(Get.parameters['id']!) != 0)
        ? int.parse(Get.parameters['id']!)
        : null;
    if (idOrder != null) {
      titleModule = "Edit";
      _getOrderById(idOrder!);
    } else {
      dateOrderController.text = DateTime.now().toString();
      numberProductsController.text = "0 products";
      finalPriceController.text = "S/. 0.0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$titleModule Order"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: numberOrderController,
            decoration: const InputDecoration(hintText: "Order #"),
          ),
          TextField(
            controller: dateOrderController,
            enabled: false,
            decoration: const InputDecoration(hintText: "Date"),
          ),
          TextField(
            controller: numberProductsController,
            enabled: false,
            decoration: const InputDecoration(hintText: "# Products"),
          ),
          TextField(
            controller: finalPriceController,
            enabled: false,
            decoration: const InputDecoration(hintText: "Final Price"),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Products", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 20),
              FilledButton(
                  onPressed: _showModalAddProduct,
                  child: const Row(children: [Icon(Icons.plus_one)]))
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('P.Unit')),
                DataColumn(label: Text('Qty')),
                DataColumn(label: Text('Total Price')),
                DataColumn(label: Text('Opts')),
              ],
              rows: productsToOrder.entries.map<DataRow>((entry) {
                Product productFound =
                    products.firstWhere((product) => product.id == entry.key);
                print(
                    "EntryKey: ${entry.key} & ProductFoundId: ${productFound.name}");
                return DataRow(cells: [
                  DataCell(Text("${productFound.id}")),
                  DataCell(Text(productFound.name)),
                  DataCell(Text("${productFound.price}")),
                  DataCell(Text("${entry.value}")),
                  DataCell(Text("${entry.value * productFound.price}")),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showModalAddProduct(
                              productToEdit: productFound,
                              quantity: entry.value);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteProductFromOrder(productFound);
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
          OutlinedButton(
              onPressed: _submitOrder, child: Text("$titleModule Order"))
        ],
      ),
    );
  }

  Future<void> _submitOrder() async {
    final response = await httpService.createOrUpdateOrder(
        idOrder: idOrder,
        numberOrder: int.parse(numberOrderController.text),
        orderDetails: orderDetails);
    if (response.statusCode == 201) {
      showMessage(context: context, message: "Order was created successfully!");
      Get.back();
    } else if (response.statusCode == 200) {
      showMessage(context: context, message: "Order was updated successfully!");
      Get.back();
    } else {
      showMessage(
          context: context,
          message: "Error occurs during list orders.",
          errorCode: response.statusCode);
    }
  }

  Future<void> _getAllProducts() async {
    final response = await httpService.getProducts();
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    }
  }

  void _showModalAddProduct({Product? productToEdit, int? quantity}) async {
    TextEditingController quantityController = TextEditingController();
    Product? productSelected = productToEdit;

    if (productToEdit != null) {
      quantityController.text = quantity.toString();
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Modal with Form'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<Product>(
                    value: productSelected,
                    onChanged: (Product? newValue) {
                      setState(() {
                        productSelected = newValue!;
                      });
                    },
                    items: products
                        .map<DropdownMenuItem<Product>>((Product product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    hint: const Text("Select a product"),
                  ),
                  TextField(
                      controller: quantityController,
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _updateProductsToOrder(
                            key: productSelected!.id!,
                            value: int.parse(quantityController.text),
                          toEdit: productToEdit != null
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add/Edit'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _updateProductsToOrder({required int key, required int value, required bool toEdit}) {
    setState(() {
      productsToOrder[key] = value;
      Product productFound =
          products.firstWhere((product) => product.id == key);
      final totalPrice = value * productFound.price;
      if(toEdit){
        OrderDetail detailFound =
        orderDetails.firstWhere((detail) => detail.product == key);
        detailFound.quantity = value;
        detailFound.totalPrice = totalPrice;
        return;
      }

      OrderDetail newDetail = OrderDetail(product: productFound.id!, quantity: value, totalPrice: totalPrice, productObject: productFound);
      orderDetails.add(newDetail);
      _updateFinalPrice();
    });
  }

  void _updateFinalPrice() {
    double finalPrice = 0;
    for (OrderDetail detail in orderDetails) {
      finalPrice += detail.totalPrice;
    }
    setState(() {
      finalPriceController.text = "S/. $finalPrice";
    });
  }

  Future<void> _getOrderById(int idOrder) async {
    final response = await httpService.getOrderById(idOrder: idOrder);
    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      setState(() {
        _orderFound = Order.fromJson(data);
        double finalPrice = 0;
        for (var detail in _orderFound!.orderDetails) {
          finalPrice += detail.totalPrice;
          productsToOrder[detail.product] = detail.quantity;
          orderDetails.add(detail);
        }
        numberOrderController.text = _orderFound!.orderNumber.toString();
        dateOrderController.text = _orderFound!.orderDate.toString();
        numberProductsController.text =
            "${_orderFound!.orderDetails.length} products";
        finalPriceController.text = "S/. $finalPrice";
      });
      print("Order found successfully!");
    }
  }

  void _deleteProductFromOrder(Product productFound) {
    setState(() {
      productsToOrder.remove(productFound.id!);
      orderDetails.removeWhere((detail) => detail.product == productFound.id);
    });
  }
}
