import 'package:flutter/material.dart';
import 'package:fractal_challenge/screens/order_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: OrderListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
