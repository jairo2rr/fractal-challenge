import 'package:fractal_challenge/screens/add_edit_order.dart';
import 'package:fractal_challenge/screens/order_list.dart';
import 'package:get/get.dart';

import '../../screens/add_edit_product.dart';

class RoutesClass{
  static String home="/my-orders";
  static String addEditOrder="/add-order";
  static String addEditProduct="/add-product";

  static String getHomeRoute()=>home;
  static String getAddEditOrderRoute()=>addEditOrder;

  static List<GetPage> routes = [
    GetPage(name: home, page: () => OrderListScreen()),
    GetPage(name: "$addEditOrder/:id", page: ()=> AddEditOrderScreen()),
    GetPage(name: addEditProduct, page: ()=>AddEditProductScreen())
  ];
}