import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/Product.dart';
import 'package:http/http.dart' as http;

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  bool statusActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add/Edit Product"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration.collapsed(hintText: "Name"),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: "Price"),
          ),
          Row(
            children: <Widget>[ Checkbox(
              onChanged: (bool? newValue) {
                setState(() {
                  statusActive = newValue ?? false;
                });
              },
              value: statusActive,
            ),
              const Text("Active")
            ],
          ),
          FilledButton(onPressed: submitProduct, child: Text("Add/Edit Product"))
        ],
      ),
    );
  }

  void submitProduct() async {
    final apiUrl = "http://10.0.2.2:8093/api/v1/product";
    final uri = Uri.parse(apiUrl);
    final product = Product(name: nameController.text,price: double.tryParse(priceController.text) ?? 0.0, productStatus: (statusActive)?1:0 );
    final response = await http.post(uri,body: json.encode(product.toJson()),headers: {'Content-Type':'application/json'});

    if(response.statusCode == 200){

    }else{

    }
  }
}
