import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/robot_data_model.dart';
import 'ble_send_util.dart';

/// 与原生交互的工具类
class NativeCommunication {
  static const platform = MethodChannel('com.example/native');

  Future<void> setupMethodChannel() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "beginPickBall") { /// 原生开启捡球按钮
        final bool pickState = call.arguments;
        BleSendUtil.setRobotStartPick(1);
        print('Received notification from Swift: $pickState');
        // 在这里处理通知
      } else if(call.method == "changeRobotMode") { /// swift 切换模式
        final String mode = call.arguments;
        if (mode == "training") {
          BleSendUtil.setRobotMode(RobotMode.training);
          print('Received notification from Swift: 训练模式');

        } else {
          BleSendUtil.setRobotMode(RobotMode.rest);
          print('Received notification from Swift: 休息模式');

        }


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