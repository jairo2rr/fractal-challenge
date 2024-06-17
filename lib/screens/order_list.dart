import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/navigation/routes.dart';
import 'package:fractal_challenge/services/http_service.dart';
import 'package:get/get.dart';
import 'package:fractal_challenge/models/order.dart';
import 'package:fractal_challenge/utils/snackbar_message.dart';

class OrderListController extends GetxController {
  RxBool loading = false.obs;
}

class OrderListScreen extends StatefulWidget {
  OrderListController? controller = Get.put(OrderListController());

  OrderListScreen({this.controller, super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  OrderListController? _controller;
  bool _isLoading = false;
  List<Order> _orderList = [];
  HttpService httpService = Get.find<HttpService>();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    loadAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order App"),
        actions: [
          OutlinedButton(
              onPressed: () {
                loadAllOrders();
              },
              child: const Icon(Icons.refresh_rounded))
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Add/Edit order",
            onPressed: () async {
              final result = await navigateToAddScreen();
              if (result != null) {
                _executeOnReturn();
              }
            },
            child: const Icon(Icons.plus_one),
          ),
          FloatingActionButton(
            heroTag: "Add/Edit product",
            onPressed: navigateToProductScreen,
            child: const Icon(Icons.plumbing_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
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
                      navigateToAddScreen(id: order.id ?? 0);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Show confirmation dialog and delete order
                      _showDeleteConfirmationDialog(order.id);
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

  Future<dynamic> navigateToAddScreen({int id = 0}) async {
    return Get.toNamed("${RoutesClass.addEditOrder}/$id");
  }

  Future<dynamic> navigateToProductScreen() async {
    return Get.toNamed(RoutesClass.addEditProduct);
  }

  Future<void> loadAllOrders() async {
    final response = await httpService.getOrders();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _orderList = data.map((object) => Order.fromJson(object)).toList();
      });
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

  Future<void> _showDeleteConfirmationDialog(int? id) async {
    Order orderFound = _orderList.firstWhere((order) => order.id == id);
    return await Get.dialog(_deleteDialog(
        order: orderFound,
        onDelete: () {
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }
          loadAllOrders();
          Get.back();
        }));
  }

  void _executeOnReturn() {
    loadAllOrders();
  }

  Widget _deleteDialog(
      {required Order order, required void Function() onDelete}) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: Get.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Are you sure to delete this order?"),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                        onPressed: () async {
                          await httpService.deleteOrderById(id: order.id!);
                          onDelete();
                        },
                        child: const Text("Delete")),
                    const SizedBox(width: 8),
                    OutlinedButton(
                        onPressed: () => {Get.back()},
                        child: const Text("Cancel")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
