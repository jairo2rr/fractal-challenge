
import 'package:fractal_challenge/services/http_service.dart';
import 'package:get/get.dart';

Future<void> registerServices() async {
  Get.put(HttpService());
}