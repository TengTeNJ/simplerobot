
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import '../models/robot_data_model.dart';
import 'ble_send_util.dart';
import 'dialog.dart';

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
            BleSendUtil.setRobotBeginNavigation(int.parse(type),int.parse(direction), int.parse(angle));
          }
          catch(error){
            print('error == $error');
          }
        }
      } else if(call.method == "endNavigation") { /// 到达位置结束导航
       /// APP 发送导航结束指令*/ // 1 到达原点  2 区域位置到达  // 0x54
        final String type = call.arguments;
        BleSendUtil.setRobotNavigationEnd(int.parse(type));
      } else if(call.method == 'robotReset') { // APP 发送给蓝牙 重置指令
        print('Received from Swift:  机器人重置');
        BleSendUtil.setRobotReset();



        Future.delayed(Duration(milliseconds: 100),() {
          BleSendUtil.setRobotReset();
          /// 机器人重置以后发送stop
          Future.delayed(Duration(milliseconds: 500), () {
            /// 0x56 发送stop
            BleSendUtil.setRobotStartPick(0);
          });
        });


      } else if(call.method == 'changeRobotSpeed') { //调节行走轮速度
        final bool speed = call.arguments;
        if (speed == true) {
          BleSendUtil.setSpeed(RobotSpeed.fast); //低速
          print('Received from Swift:  调节机器人速度0.42');
        } else {
          BleSendUtil.setSpeed(RobotSpeed.faster); //高速
          print('Received from Swift:  调节机器人速度0.45');
        }
      } else if(call.method == 'changeRobotReset') { // 调节机器人休息时间间隔
        final bool resetTime = call.arguments;
        if (resetTime == true) {
          BleSendUtil.setRobotWaitTime(RobotResetGap.three); // 一分钟
          print('Received from Swift:  调节机器人休息时间间隔1分钟');
        } else {
          BleSendUtil.setRobotWaitTime(RobotResetGap.three); // 三分钟
          print('Received from Swift:  调节机器人休息时间间隔3分钟');
        }
      } else if(call.method == 'changeRobotBallType') {
        final String type = call.arguments;
        print('Received from Swift:  调节机器人ball Type${type}');
        BleSendUtil.setRobotCollectingWheelSpeed(int.parse(type));
      }
      else if(call.method == 'popToControl') { // 退出到遥控界面
        final bool isSkip = call.arguments;
        if (isSkip) {
          NavigatorUtil.pop();
        } else {
          NavigatorUtil.pop();
          NavigatorUtil.pop();
          NavigatorUtil.pop();
        }
      }

      // else if(call.method == 'lostViewTimeout') { // 失去视野超过20s,切换成1.0的捡球模式
      //   BleSendUtil.setRobotMode(RobotMode.onepick);
      //   print("Received from Swift机器人失去视野10s了");
      //
      //
      // }
    });
  }

  Future<void> sendDataToNative(String type,int navigationType) async {
    try {
      if (type =="RobotBallFullSingle") {
        await platfrom1.invokeMethod('${type}', '');
      } else if(type == 'RobotBeginNaviSingle') {
        await platfrom1.invokeMethod('${type}', '');
      } else if(type == 'RobotEndNaviSingle') {
        await platfrom1.invokeMethod('${type}', '${navigationType}');
      } else if(type == 'RobotObstacleAvoidanceEnd') {
        await platfrom1.invokeMethod('${type}','');
      } else if (type == 'bluetoothDisconnectSingle') {
        await platfrom1.invokeMethod('${type}','');
      } else if (type == 'RobotReceiveStartOrStopSingle') {
        await platfrom1.invokeMethod('${type}','${navigationType}');
      }

      print('sendDataToNative6666');
    } on PlatformException catch(e) {
      print('Failed to open native screen: ${e.message}');
    }
  }
}