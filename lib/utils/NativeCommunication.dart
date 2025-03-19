import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/robot_data_model.dart';
import 'ble_send_util.dart';

/// 与原生交互的工具类
class NativeCommunication {
  static const platform = MethodChannel('com.example/native');
  static const platformToSwift = MethodChannel('com.example.fluttertoswift');
  static const platfrom1 = MethodChannel('native_screen');


  Future<void> getDataFromNative() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "beginPickBall") { /// 原生开启捡球按钮
        final bool pickState = call.arguments;
        if (pickState == true) {
          BleSendUtil.setRobotStartPick(1);
          print('Received notification from Swift: 开启捡球');
        } else {
          BleSendUtil.setRobotStartPick(0);
          print('Received notification from Swift: 暂停捡球');
        }
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
      } else if(call.method == "beginNavigation") { /// 通知机器人开始导航
       /// final String mode = call.arguments;
        /// （1个字节：电子围栏1，区域导航2，原点导航3  + 1个字节机器人转向：1向左，2向右+2个字节机器人转向角度）
         final  params = call.arguments;
        // 处理返回的 Dictionary 参数
        if (params is Map) {
          print('Received from Swift: $params');
          try{
            final String type = params['type'];
            final String direction = params['direction'];
            final String angle = params['angle'];
            BleSendUtil.setRobotBeginNavigation(3,int.parse(direction), int.parse(angle));
          }
          catch(error){
            print('error == $error');
          }
        }
      } else if(call.method == "endNavigation") { /// 到达位置结束导航
       /// APP 发送导航结束指令*/ // 1 到达原点  2 区域位置到达  // 0x54
        final String type = call.arguments;
        BleSendUtil.setRobotNavigationEnd(int.parse(type));
      }
    });
  }

  Future<void> sendDataToNative(String type) async {
    try {
      if (type =="RobotBallFullSingle") {
        await platfrom1.invokeMethod('${type}', '');
      } else if(type == 'RobotBeginNaviSingle') {
        await platfrom1.invokeMethod('${type}', '');
      } else if(type == 'RobotEndNaviSingle') {
        await platfrom1.invokeMethod('${type}', '');
      }

      print('sendDataToNative6666');
    } on PlatformException catch(e) {
      print('Failed to open native screen: ${e.message}');
    }
  }
}