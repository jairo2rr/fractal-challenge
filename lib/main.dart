import 'package:flutter/material.dart';
import 'package:fractal_challenge/models/navigation/routes.dart';
import 'package:fractal_challenge/utils/utils.dart';
import 'package:get/get.dart';

void main() async{
  await registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(),
      initialRoute: RoutesClass.home,
      getPages: RoutesClass.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
