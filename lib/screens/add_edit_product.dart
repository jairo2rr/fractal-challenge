import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/product.dart';
import 'package:fractal_challenge/services/http_service.dart';
import 'package:fractal_challenge/utils/snackbar_message.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

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
  HttpService httpService = Get.find<HttpService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add/Edit Product"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration.collapsed(hintText: "Name"),
          ),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Price"),
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
          FilledButton(onPressed: submitProduct, child: const Text("Add/Edit Product"))
        ],
      ),
    );
  }

  Future<void> submitProduct() async {
    final response = await httpService.addProduct(name: nameController.text, price: double.tryParse(priceController.text) ?? 0.0, statusActive: statusActive);
    if(response.statusCode == 201){
      showMessage(context: context, message: "Product was created successfully!");
      Get.back();
    }else{
      showMessage(
          context: context,
          message: "Error occurs during add product.",
          errorCode: response.statusCode);
    }
  }
}
