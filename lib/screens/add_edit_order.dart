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
    }else{
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
            decoration: InputDecoration(hintText: "Date"),
          ),
          TextField(
          controller: numberProductsController,
            decoration: InputDecoration(hintText: "# Products"),
          ),
          TextField(
            controller: finalPriceController,
            decoration: InputDecoration(hintText: "Final Price"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Products",style: TextStyle(fontSize: 20)),
              SizedBox(width: 20),
              FilledButton(
                  onPressed: _showModalAddProduct, child: Row(children: [Icon(Icons.plus_one)]) )
            ],
          )
          ,
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
                Product productFound = products.firstWhere((product)=>product.id == entry.key);
                return DataRow(cells: [
                  DataCell(Text("${productFound.id}")),
                  DataCell(Text(productFound.name)),
                  DataCell(Text("${productFound.price}")),
                  DataCell(Text("${entry.value}")),
                  DataCell(Text("${entry.value*productFound.price}")),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
          OutlinedButton(onPressed: () {submitOrder();}, child: Text("$titleModule Order"))
        ],
      ),
    );
  }

  Future<void> submitOrder() async {
    final numberOrder = int.parse(numberOrderController.text);

    final apiUrl = "http://10.0.2.2:8093/api/v1/order";
    final apiUri = Uri.parse(apiUrl);
    if(idOrder!=null){
      final order = Order(id: idOrder,orderNumber: numberOrder, orderDate: DateTime.now(), orderStatus: OrderStatus.Pending, orderDetails: orderDetails);
      final response = await http.put(apiUri, body: json.encode(order.toJson()),headers: {'Content-Type': 'application/json'});
    }else{
      final order = Order(orderNumber: numberOrder, orderDate: DateTime.now(), orderStatus: OrderStatus.Pending, orderDetails: orderDetails);
      final response = await http.post(apiUri, body: json.encode(order.toJson()),headers: {'Content-Type': 'application/json'});
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

  void _showModalAddProduct() async {
    TextEditingController quantityController = TextEditingController();

    Product? productSelected;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modal with Form'),
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
                      productsToOrder[productSelected!.id!] =
                          int.parse(quantityController.text);
                      final totalPrice = int.parse(quantityController.text)*productSelected!.price;
                      orderDetails.add(OrderDetail(id: null,product: productSelected!.id! ,productObject: productSelected!, quantity: int.parse(quantityController.text), totalPrice: totalPrice));
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Add/Edit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getOrderById(int idOrder) async {
    final apiUrl = "http://10.0.2.2:8093/api/v1/order/$idOrder";
    final apiUri = Uri.parse(apiUrl);
    final response =
    await http.get(apiUri, headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 201) {
      dynamic data = json.decode(response.body);
      setState(() {
        _orderFound = Order.fromJson(data);
        double finalPrice = 0;
        for (var element in _orderFound!.orderDetails) {
          finalPrice +=element.totalPrice;
          productsToOrder[element.id!] = element.quantity;
          orderDetails.add(element);
        }
        numberOrderController.text = _orderFound!.orderNumber.toString();
        dateOrderController.text = _orderFound!.orderDate.toString();
        numberProductsController.text = "${_orderFound!.orderDetails.length} products";
        finalPriceController.text = "S/. ${finalPrice}";
      });
      print("Order found successfully!");
    }
  }
}

