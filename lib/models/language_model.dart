import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LanguageModel extends ChangeNotifier {
  // 默认中文
  Locale _currentLocale = Locale('zh');

  // 支持的语言列表
  final Map<String, Map<String, String>> _localizedValues = {
    'zh': {
      '扫描':'将你的手机连接到机器人的蓝牙\n蓝牙名称为',
      '当前的蓝牙设备': '当前蓝牙',
      '连接':"连接",
      '连接成功':"蓝牙设备连接成功",
      '数据':"数据",
      '今天':"捡球",
      '今日使用':"今日使用",
      '消耗卡路里':"消耗卡路里",
      '自动捡球':"自动捡球",
      'AI模式':"AI模式",
      '返回':"返回",
      '智能捡球模式':"智能捡球模式",
      '智能捡球模式描述':"在智能模式下，Seekerbot将始终待在球场边界范围内 你需将捡球机放置在地图上的指定区域，待球装满后，可选择一个回球位置。",
      '跳过':"跳过",
      '镜头位置':"镜头位置",
      '镜头位置描述':"将手机支架放置在网球场球网的任意一端 然后将摄像头对准你想要拍摄的球场方向，同时确保支架高度高于球网。",
      '注意事项':"注意事项",
      '阳关提示':"手机避免直接暴露在阳光下",
      '手机固定提示':"确保固定好您的手机",
      '手机摄像头提示':"避免遮挡摄像头",
      '死球区域提示':"清理死角区球",
      '收球类型' : "收球类型",
      '车轮速度' : "车轮速度",
      '个人资料' : "个人资料",
      '故障引导' : "故障引导",
      '调节机器人收球速度': "调节机器人收球速度",
      '你可通过调节档位调整捡球机的移动速度':"你可通过调节档位调整捡球机的移动速度",
      '1档可节省20%电量':"1档可节省20%电量",
      '关于故障与解决方法':"关于故障与解决方法",
      '1.缠绕球网':"1.缠绕球网",
      '缠绕球网解决办法':"解决方法: 将网与机器分离，并重新启动机器人",

      '2.在狭隘的直角空间卡停':"2.在狭隘的直角空间卡停",
      '卡停解决办法':"解决方法: 您可以尝试切换手动模式遥控机器人离开区域",

      '03.车轮卡停':"03.车轮卡停",
      '车轮卡停解决办法':"解决方案: 检查轮子是否有异物，移除后重新启动",

      '总计使用':"总计使用",
      '总捡球数':"总捡球数",
      '我的训练':"我的训练",
      '最高记录': "最高记录",









      // 添加所有需要翻译的文本
    },
    'en': {
      '扫描':'Connect your phone to your bots Bluetooth.The Bluetooth name is',
      '当前的蓝牙设备': 'Current Bluetooth',
      '连接':"Connect",
      '连接成功':"Bluetooth device connection \n successful",
      '今天':"Today",
      '今日使用':"Today Use",
      '消耗卡路里':"Calorie",
      '数据':"Stats",
      '自动捡球':"Auto",
      'AI模式':"AI Mode",
      '返回':"Back",
      '智能捡球模式':"Intelligent Mode",
      '智能捡球模式描述':"In the intelligent mode, your robot will remain within the boundaries of the court,and you can select the position to which the robot returnsafter the balls are full by clicking the HOME icon",
      '跳过':"Skip",
      '镜头位置':"Camera Placement",
      '镜头位置描述':"Place the phone mount at either end of the tennis court net,and position the camera towards the direction of the court you wish to capture,ensuring that the mount is set higher than the net.",
      '注意事项':"Reminders",
      '阳关提示':"Avoid direct exposure to sunlight",
      '手机固定提示':"Secure your phone",
      '手机摄像头提示':"Avoid covering the camera",
      '死球区域提示':"Clear dead zone balls",
      '收球类型' : "Ball Type",
      '车轮速度' : "Roller Speed",
      '个人资料' : "Profile",
      '故障引导' : "Fault",
      '调节机器人收球速度': "You can adjust the ball collection speed of the robot.",
      '你可通过调节档位调整捡球机的移动速度':"You can adjust the speed of the robots wheel movement through different gears",
      '1档可节省20%电量':"Save 20% of the battery.",

      '关于故障与解决方法':"Faults and Solutions",
      '1.缠绕球网':"1.Faults and Solutions",
      '缠绕球网解决办法':"Solution: \nDetach the net from the SeekerBot\n and restart the machine.",

      '2.在狭隘的直角空间卡停':"2.Stuck in Tight Right-Angled Space",
      '卡停解决办法':"Solution:\n Switch to manual mode and guide the SeekerBot out of the area.",

      '03.车轮卡停':"03.Wheel Obstructed",
      '车轮卡停解决办法':"Solution: \nInspect the wheels for foreign objects or any object sticking out and remove the obstructions.",

      '总计使用':"Total In-Use",
      '总捡球数':"Total Collections",
      '我的训练':" Time on Trainings",
      '最高记录': "Highest ",









      // 添加所有需要翻译的文本
    },
  };

  Locale get currentLocale => _currentLocale;

  set currentLocale(Locale newLocale) {
    _currentLocale = newLocale;
  }

  String getText(String key) {
    return _localizedValues[_currentLocale.languageCode]?[key] ?? key;
  }

  void changeLanguage(Locale locale) {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
  }
}
