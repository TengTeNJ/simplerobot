import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/ble_send_util.dart';
import 'package:tennis_robot/utils/color.dart';
import 'dart:math' as math;
import 'package:tennis_robot/utils/robot_manager.dart';
import 'package:vibration/vibration.dart';

class RemoteControlView extends StatefulWidget {
  const RemoteControlView({super.key});

  @override
  State<RemoteControlView> createState() => _RemoteControlViewState();
}

class _RemoteControlViewState extends State<RemoteControlView> {
  Offset position = Offset(0, 0); // 初始位置为试图A的中心
  bool isMove = false; // 滑动标识
  int index = 0;// 索引，记录第一次拖动的方向
  Offset firstPosition = Offset(0, 0);

  int _topImageIndex = 0;
  List<String> _topImages = [
    'images/control/control_top.png',
    'images/control/control_top_high.png'
  ];

  int _bottomImageIndex = 0;
  List<String> _bottomImages = [
    'images/control/control_bottom.png',
    'images/control/control_bottom_high.png'
  ];

  int _leftImageIndex = 0;
  List<String> _leftImages = [
    'images/control/control_left.png',
    'images/control/control_left_high.png'
  ];

  int _rightImageIndex = 0;
  List<String> _rightImages = [
    'images/control/control_right.png',
    'images/control/control_right_high.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 40 *3,
      height: Constants.screenWidth(context) - 40*3,
      decoration: BoxDecoration(
          color: hexStringToColor('#2B2C30'),
          borderRadius: BorderRadius.circular(
              (Constants.screenWidth(context) - 40*3) / 2.0)),
      child: Stack(
        children: [
          Center(
            // child: Image(
            //   image: AssetImage('images/connect/remote_control.png'),
            //   height: Constants.screenWidth(context) - 40*3 - 96,
            // ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 20,
                  left: (Constants.screenWidth(context) - 40*3)/2 - 20,
                  child: GestureDetector(
                    onLongPress: () {
                      BleSendUtil.setRobotAngle(0);
                      setState(() {
                        _topImageIndex = 1;
                        Vibration.vibrate();
                      });
                    },
                    onLongPressUp: (){
                      setState(() {
                        _topImageIndex = 0;
                        Vibration.cancel();
                      });
                      },
                    child: Image.asset('${_topImages[_topImageIndex]}',width: 40,height: 30), // 替换为你的图片路径
                  ),
                ),
                Positioned(
                  top: (Constants.screenWidth(context) - 40*3) - 30 - 20,
                  right: (Constants.screenWidth(context) - 40*3)/2 - 20,
                  child: GestureDetector(
                    onLongPress: () {
                      BleSendUtil.setRobotAngle(180);
                      setState(() {
                        _bottomImageIndex = 1;
                        Vibration.vibrate();
                      });
                    },
                    onLongPressUp: (){
                      setState(() {
                        _bottomImageIndex = 0;
                        Vibration.cancel();
                      });
                    },
                    child: Image.asset('${_bottomImages[_bottomImageIndex]}',width: 40,height: 30), // 替换为你的图片路径
                  ),
                ),
                Positioned(
                  bottom: (Constants.screenWidth(context) - 40*3)/2 - 20,
                  left: 20,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        BleSendUtil.setRobotAngle(270);
                        _leftImageIndex = 1;
                        Vibration.vibrate();
                      });
                    },
                    onLongPressUp: (){
                      setState(() {
                        Vibration.cancel();
                        _leftImageIndex = 0;
                      });
                    },
                    child: Image.asset('${_leftImages[_leftImageIndex]}',width: 30,height: 40), // 替换为你的图片路径
                  ),
                ),
                Positioned(
                  bottom: (Constants.screenWidth(context) - 40*3)/2 - 20,
                  right:20,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        BleSendUtil.setRobotAngle(90);
                        _rightImageIndex = 1;
                        Vibration.vibrate();
                      });
                    },
                    onLongPressUp: (){
                      setState(() {
                        Vibration.cancel();
                        _rightImageIndex = 0;
                      });
                    },
                    child: Image.asset('${_rightImages[_rightImageIndex]}',width: 30,height: 40), // 替换为你的图片路径
                  ),
                ),
              ],
            ),

          ),
          Positioned(
              left: (Constants.screenWidth(context) - 40*3 - 44) / 2.0,
              top: (Constants.screenWidth(context) - 40*3 - 44) / 2.0,
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    // 开始拖拽
                    isMove = true;
                  });
                },
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  // 更新圆点的位置
                  setState(() {
                    position += details.delta;
                    // 限制圆点在试图A内部移动
                    position = _clampOffsetToCircle(position, ((Constants.screenWidth(context) - 40*3) / 2.0));
                   // print('位置信息为${position}');
                    // var angle = math.atan2(position.dy, position.dx);
                    // var degrees = angle * (180 / math.pi) + 90;
                    // print('拖动时轮盘的角度${degrees}');

                    index += 1;
                    if (index == 3) {
                      firstPosition = Offset(0, position.dy);
                      print('开始拖动y的偏移量${position.dy}');
                    }

                    var yOffset = position.dy;
                    if (firstPosition.dy > 0 &&yOffset < 0) {
                      yOffset = math.max(position.dy.abs(), position.dy);
                      position = Offset(position.dx, yOffset);
                      // print('下半圆');
                    }

                    if (firstPosition.dy <0 && yOffset > 0) {
                      yOffset = math.min(position.dy.abs(), position.dy);
                      position = Offset(position.dx, -yOffset);
                      // print('上半圆');
                    }

                    var angle = math.atan2(position.dy, position.dx);
                    var degrees = angle * (180 / math.pi) + 90;
                    if (degrees < 0) {
                      degrees = degrees + 360;
                    }
                    print('${getCurrentTime()}---角度${degrees.toInt()}');
                    BleSendUtil.setRobotAngle(degrees.toInt());

                  });
                },
                onPanEnd: (details) {
                  // 手指松开时，将圆点移动回试图A的中心
                  setState(() {
                    index = 0;
                    // 结束拖拽
                    firstPosition = Offset(0, 0);
                    position = Offset(0, 0);
                    isMove = false;
                    BleSendUtil.setRobotAngle(0);

                  });
                },
                child: Transform.translate(
                  offset: position,
                  child: Image(
                    image: AssetImage(isMove
                        ? 'images/connect/control_point_move.png'
                        : 'images/connect/control_point.png'),
                    height: 44,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String getCurrentTime() {
    // 获取当前时间
    DateTime now = DateTime.now();
    // 格式化时间为字符串
    String timeString = "${now.hour}:${now.minute}:${now.second}:${now.millisecond}";
    // 打印时间
    // print(timeString);
    return timeString;
  }
  /*限制圆环在圆形内拖拽*/
  Offset _clampOffsetToCircle(Offset offset, double radius) {
    double distanceSquared = offset.dx * offset.dx + offset.dy * offset.dy;
    if (distanceSquared <= radius * radius) {
      // 如果已经在圆内或圆上，则无需调整
      return offset;
    } else {
      // 如果在圆外，则计算到圆边缘的最近点
      double distance = math.sqrt(distanceSquared);
      double x = offset.dx * radius / distance;
      double y = offset.dy * radius / distance;
      return Offset(x, y);
    }
  }
}
