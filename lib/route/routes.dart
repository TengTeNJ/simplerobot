import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tennis_robot/UserInfo/user_info_input_controller.dart';
import 'package:tennis_robot/connect/connect_robot_controller.dart';
import 'package:tennis_robot/connect/connect_robot_success_controller.dart';
import 'package:tennis_robot/pickmode/pick_mode_controller.dart';
import 'package:tennis_robot/profile/profile_controller.dart';
import 'package:tennis_robot/robotstats/robot_stats_controller.dart';
import 'package:tennis_robot/root_page.dart';
import 'package:tennis_robot/startPage/action_controller.dart';
import 'package:tennis_robot/trainmode/train_mode_controller.dart';

class Routes {
  static const String connect = 'connect'; // 链接机器人界面

  static const String trainMode = 'trainMode'; // 训练模式

  /// 简化版的app
  static const String action = 'action'; // 启动页
  static const String pickMode = 'pickMode'; // 捡球模式
  static const String stats = 'stats';// 统计数据
  static const String setting = 'setting';// 设置界面
  static const String connectSuccess = 'connectSuccess'; // 连接成功界面
  static const String inputUserInfo = 'inputUserInfo';// 用户信息输入界面

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {

      case action:
        return MaterialPageRoute(builder: (_) => ActionController());
      case pickMode:
        return MaterialPageRoute(builder: (_) => PickModeController());
      case stats:
        return MaterialPageRoute(builder: (_) => RobotStatsController());
      case setting:
      return MaterialPageRoute(builder: (_) => ProfileController());

      case inputUserInfo:
        return MaterialPageRoute(builder: (_) => UserInfoInputController());
      case connectSuccess:
        return MaterialPageRoute(builder: (_) => ConnectRobotSuccessController());
      case connect:
        return MaterialPageRoute(builder: (_) => ConnectRobotController());

      case trainMode:
        return MaterialPageRoute(builder: (_) => TrainModeController());
    }
  };
}