import 'dart:convert';
import 'dart:ffi';

import 'package:fractal_challenge/models/order.dart';
import 'package:fractal_challenge/models/product.dart';
import 'package:http/http.dart' as http;


class HttpService{
  final String _baseApiURL = "http://10.0.2.2:8093/api/v1";
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> getOrders() async{
    final uri = Uri.parse("$_baseApiURL/orders");
    return await http.get(uri, headers: _headers);
  }

  Future<dynamic> deleteOrderById({required int id}) async {
    final uri = Uri.parse("$_baseApiURL/order/$id");
    return await http.delete(uri, headers: _headers);
  }

  Future<dynamic> addProduct({required String name, required double price, required bool statusActive}) async{
    final uri = Uri.parse("$_baseApiURL/product");
    final product = Product(name: name,price:  price, productStatus: (statusActive)?1:0 );
    return await http.post(uri,body: json.encode(product.toJson()),headers: {'Content-Type':'application/json'});
  }

  Future<dynamic> createOrUpdateOrder({required int? idOrder, required int numberOrder, required List<OrderDetail> orderDetails}) async {
    final uri = Uri.parse("$_baseApiURL/order");
    if (idOrder != null) {
      final order = Order(
          id: idOrder,
          orderNumber: numberOrder,
          orderDate: DateTime.now(),
          orderStatus: OrderStatus.Pending,
          orderDetails: orderDetails);
      return await http.put(uri,
          body: json.encode(order.toJson()),
          headers: {'Content-Type': 'application/json'});
    } else {
      final order = Order(
          orderNumber: numberOrder,
          orderDate: DateTime.now(),
          orderStatus: OrderStatus.Pending,
          orderDetails: orderDetails);
      return await http.post(uri,
          body: json.encode(order.toJson()),
          headers: {'Content-Type': 'application/json'});
    }
  }

  Future<dynamic> getProducts() async {
    final uri = Uri.parse("$_baseApiURL/products");
    return await http.get(uri, headers: {'Content-Type': 'application/json'});
  }

  Future<dynamic> getOrderById({required int idOrder}) async {
    final uri = Uri.parse("$_baseApiURL/order/$idOrder");
    return await http.get(uri, headers: {'Content-Type': 'application/json'});
  }
}