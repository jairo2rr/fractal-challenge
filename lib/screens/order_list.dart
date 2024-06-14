import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/screens/add_edit_order.dart';
import 'package:fractal_challenge/screens/add_edit_product.dart';
import 'package:http/http.dart' as http;
import 'package:fractal_challenge/models/Order.dart';
import 'package:fractal_challenge/utils/SnackBarMessage.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  bool _isLoading = true;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();

    loadAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order App")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Add/Edit order",
            onPressed: () async {
              await navigateToAddScreen(id:null);
              _executeOnReturn();
            },
            child: Icon(Icons.plus_one),
          ),
          FloatingActionButton(
            heroTag: "Add/Edit product",
            onPressed: navigateToProductScreen,
            child: Icon(Icons.plumbing_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Order#')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('#Products')),
            DataColumn(label: Text('F.Price')),
            DataColumn(label: Text('Opts')),
          ],
          rows: _orderList.map((order) {
            return DataRow(cells: [
              DataCell(Text(order.id.toString())),
              DataCell(Text("${order.orderNumber}")),
              DataCell(Text(order.orderDate.toString())),
              DataCell(Text("${order.orderDetails.length} products")),
              DataCell(Text("")),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit order screen, passing order ID
                      navigateToAddScreen(id:order.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Show confirmation dialog and delete order
                      showDeleteConfirmationDialog(order.id);
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Future<void> navigateToAddScreen({int? id}) async {
    final route = MaterialPageRoute(builder: (context) => AddEditOrderScreen(orderId: id));
    await Navigator.push(context, route);
  }

  void navigateToProductScreen(){
    final route = MaterialPageRoute(builder: (context) => AddEditProductScreen());
    Navigator.push(context, route);
  }

  Future<void> loadAllOrders() async {
    final apiUrl = "http://10.0.2.2:8093/api/v1/orders";
    final uri = Uri.parse(apiUrl);
    final response =
        await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _orderList = data.map((object) => Order.fromJson(object)).toList();
      });
      print(_orderList);
      _isLoading = false;
      showMessage(context: context, message: "Order was listed successfully!");
    } else {
      _isLoading = false;
      showMessage(
          context: context,
          message: "Error occurs during list orders.",
          errorCode: response.statusCode);
    }
  }

  void showDeleteConfirmationDialog(int? id) {}
  void _executeOnReturn(){
    loadAllOrders();
  }
}
