import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tennis_robot/choosearea/choose_area_controller.dart';
import 'package:tennis_robot/connect/connect_robot_controller.dart';
import 'package:tennis_robot/home/home_page_controller.dart';
import 'package:tennis_robot/pickmode/pick_mode_controller.dart';
import 'package:tennis_robot/profile/profile_controller.dart';
import 'package:tennis_robot/robotstats/robot_stats_controller.dart';
import 'package:tennis_robot/root_page.dart';
import 'package:tennis_robot/selectmode/select_mode_controller.dart';
import 'package:tennis_robot/startPage/action_controller.dart';
import 'package:tennis_robot/trainmode/train_mode_controller.dart';

class Routes {
  static const String home = 'home'; // 主页
  static const String selectMode = 'selectMode'; // 选择模式界面
  static const String connect = 'connect'; // 链接机器人界面
  static const String selectArea = 'selectArea'; // 选择区域界面
  static const String trainMode = 'trainMode'; // 训练模式

  /// 简化版的app
  static const String action = 'action'; // 启动页
  static const String pickMode = 'pickMode'; // 捡球模式
  static const String stats = 'stats';// 统计数据
  static const String setting = 'setting';// 设置界面

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => RootPageController());
      case action:
        return MaterialPageRoute(builder: (_) => ActionController());
      case pickMode:
        return MaterialPageRoute(builder: (_) => PickModeController());
      case stats:
        return MaterialPageRoute(builder: (_) => RobotStatsController());
      case setting:
      return MaterialPageRoute(builder: (_) => ProfileController());

      case selectMode:
        return MaterialPageRoute(builder: (_) => SelectModeController());
      case connect:
        return MaterialPageRoute(builder: (_) => ConnectRobotController());
      case selectArea:
        return MaterialPageRoute(builder: (_) => ChooseAreaController());
      case trainMode:
        return MaterialPageRoute(builder: (_) => TrainModeController());
    }
  };
}