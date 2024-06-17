import 'package:flutter/material.dart';

void showMessage({required BuildContext context ,required String message,int? errorCode = null}){
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: (errorCode != null ) ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}