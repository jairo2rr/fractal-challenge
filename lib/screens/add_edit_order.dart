import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/Order.dart';
import 'package:fractal_challenge/utils/SnackBarMessage.dart';
import 'package:http/http.dart' as http;
import 'package:fractal_challenge/models/Product.dart';
import 'package:fractal_challenge/models/Order.dart';

class AddEditOrderScreen extends StatefulWidget {
  final int? orderId;

  const AddEditOrderScreen({this.orderId, super.key});

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProducts();

    idOrder = widget.orderId;
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
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: numberOrderController,
            decoration: InputDecoration(hintText: "Order #"),
          ),
          TextField(
            controller: dateOrderController,
            enabled: false,
            decoration: InputDecoration(hintText: "Date"),
          ),
          TextField(
            controller: numberProductsController,
            enabled: false,
            decoration: InputDecoration(hintText: "# Products"),
          ),
          TextField(
            controller: finalPriceController,
            enabled: false,
            decoration: InputDecoration(hintText: "Final Price"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Products", style: TextStyle(fontSize: 20)),
              SizedBox(width: 20),
              FilledButton(
                  onPressed: _showModalAddProduct,
                  child: Row(children: [Icon(Icons.plus_one)]))
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showModalAddProduct(productToEdit: productFound, quantity: entry.value);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
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
              onPressed: submitOrder, child: Text("$titleModule Order"))
        ],
      ),
    );
  }

  Future<void> submitOrder() async {
    final numberOrder = int.parse(numberOrderController.text);

    final apiUrl = "http://10.0.2.2:8093/api/v1/order";
    final apiUri = Uri.parse(apiUrl);
    if (idOrder != null) {
      final order = Order(
          id: idOrder,
          orderNumber: numberOrder,
          orderDate: DateTime.now(),
          orderStatus: OrderStatus.Pending,
          orderDetails: orderDetails);
      final response = await http.put(apiUri,
          body: json.encode(order.toJson()),
          headers: {'Content-Type': 'application/json'});
    } else {
      final order = Order(
          orderNumber: numberOrder,
          orderDate: DateTime.now(),
          orderStatus: OrderStatus.Pending,
          orderDetails: orderDetails);
      final response = await http.post(apiUri,
          body: json.encode(order.toJson()),
          headers: {'Content-Type': 'application/json'});
    }
  }

  Future<void> _getAllProducts() async {
    final apiUrl = "http://10.0.2.2:8093/api/v1/products";
    final apiUri = Uri.parse(apiUrl);
    final response =
        await http.get(apiUri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
      print("Products listed successfully!");
    }
  }

  void _showModalAddProduct({Product? productToEdit, int? quantity}) async {
    TextEditingController quantityController = TextEditingController();
    Product? productSelected = productToEdit;

    if(productToEdit!=null){
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
                    hint: Text("Select a product"),
                  ),
                  TextField(
                      controller: quantityController,
                      decoration: InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _updateProductsToOrder(key: productSelected!.id!, value: int.parse(quantityController.text));
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Add/Edit'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _updateProductsToOrder({required int key, required int value}){
    setState(() {
      productsToOrder[key] = value;
      Product productFound = products.firstWhere((product) => product.id == key);
      final totalPrice = value * productFound.price;
      OrderDetail detailFound = orderDetails.firstWhere((detail) => detail.product == key);
      detailFound.quantity = value;
      detailFound.totalPrice = totalPrice;

      _updateFinalPrice();
    });
  }

  void _updateFinalPrice(){
    double finalPrice = 0;
    for(OrderDetail detail in orderDetails){
      finalPrice += detail.totalPrice;
    }
    finalPriceController.text = "S/. $finalPrice";

  }

  Future<void> _getOrderById(int idOrder) async {
    final apiUrl = "http://10.0.2.2:8093/api/v1/order/$idOrder";
    final apiUri = Uri.parse(apiUrl);
    final response =
        await http.get(apiUri, headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
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
    });
  }
}
