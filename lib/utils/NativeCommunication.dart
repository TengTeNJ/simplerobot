import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 与原生交互的工具类
class NativeCommunication {
  static const platform = MethodChannel('com.example/native');

  Future<void> setupMethodChannel() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "beginPickBall") { /// 开启捡球按钮
        final bool pickState = call.arguments;
        print('Received notification from Swift: $pickState');
        // 在这里处理通知
      }
    });
  }


Future<String> getDataFromNative() async {
    try {
      final String result = await platform.invokeMethod('getNativeData');
      return result;
    } on PlatformException catch (e) {
      return "Error: '${e.message}'.";
    }
  }

  void sendDataToNative(String data) async {
    try {
      await platform.invokeMethod('receiveData', data);
    } on PlatformException catch (e) {
      print("Failed to send data: '${e.message}'.");
    }
  }
}