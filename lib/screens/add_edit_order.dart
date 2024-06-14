import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/utils/SnackBarMessage.dart';
import 'package:http/http.dart' as http;
import 'package:fractal_challenge/models/Product.dart';

class AddEditOrderScreen extends StatefulWidget {
  final int? orderId;

  const AddEditOrderScreen({this.orderId, super.key});

  @override
  State<AddEditOrderScreen> createState() => _AddEditOrderScreenState();
}

class _AddEditOrderScreenState extends State<AddEditOrderScreen> {
  int? idOrder;
  TextEditingController numberOrderController = TextEditingController();
  String titleModule = "Add";
  List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProducts();
    idOrder = widget.orderId;
    if (idOrder != null) {
      titleModule = "Edit";
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
            decoration: InputDecoration(hintText: "Date"),
          ),
          TextField(
            decoration: InputDecoration(hintText: "# Products"),
          ),
          TextField(
            decoration: InputDecoration(hintText: "Final Price"),
          ),
          FilledButton(
              onPressed: _showModalAddProduct, child: Text("Add new product")),
          OutlinedButton(onPressed: () {}, child: Text("$titleModule Order"))
        ],
      ),
    );
  }

  Future<void> submitOrder() async {
    final numberOrder = numberOrderController.text;
    final order = {
      "id": "",
      "orderNumber": numberOrder,
      "orderDate": "",
      "orderStatus": "",
      "orderDetails": "",
    };
    final apiUrl = "http://10.0.2.2:8093/api/v1/product";
    final apiUri = Uri.parse(apiUrl);
    final response = await http.post(apiUri, body: order);

    print(response);
  }

  void _getAllProducts() async{
    final apiUrl = "http://10.0.2.2:8093/api/v1/products";
    final apiUri = Uri.parse(apiUrl);
    final response = await http.get(apiUri);
    if(response.statusCode == 200){
      products = json.decode(response.body);
      showMessage(context: context, message: "Products listed successfully!");
    }
  }

  void _showModalAddProduct() async {
    String selectedOption = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modal with Form'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    selectedOption = newValue!;
                  },
                  items: <String>[
                    'Option 1',
                    'Option 2',
                    'Option 3',
                    'Option 4',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Enter your name'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Función para guardar el formulario
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
}
