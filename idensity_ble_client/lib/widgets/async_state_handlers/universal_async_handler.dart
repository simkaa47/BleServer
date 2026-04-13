import 'package:flutter/material.dart';

class UniversalAsyncHandler {
  static Widget onLoading(String serviceName){
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text("$serviceName - ожидание"),
          ],
        ),
      );
  }

  static Widget onError(String serviceName, Object error, StackTrace stackTrace){
    return Center(
        child: Text(
          "Ожидание сервиса устройств - $error",
          style: const TextStyle(color: Colors.red),
        ),
      );
  }
}