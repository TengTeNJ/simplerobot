import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tennis_robot/constant/constants.dart';
import '../models/robot_data_model.dart';
import 'package:tennis_robot/utils/string_util.dart';


enum ManualFetchType {
  device, // 设备信息
  robotStatu,
  warnInfo,
  errorInfo,
  mode,
  speed,
  coordinate,
  ballsInView
}

/*切换机器人模式*/
List<int> changeRobotMode(RobotMode mode) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x35;
  int data = mode.index;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('切换机器人模式:${[start, length, cmd, data, cs, end]}');
  // EasyLoading.showToast('${[start, length, cmd, data, cs, end]}');

  return [start, length, cmd, data, cs, end];
}

/*心跳*/
List<int> heartBeatData() {
  int v = 0xA5 + 0x05 + 0x30;
  List<int> values = [0xA5, 0x05, 0x30, v, 0xAA];
  print('心跳${values}');
  return values;
}

/*清零*/
List<int> clearCountData() {
  int start = kDataFrameHeader;
  int length = 5;
  int cmd = 0x38;
  int cs = start + length + cmd;
  int end = kDataFrameFoot;
  print('清零:${[start, length, cmd, cs, end]}');
  return [start, length, cmd, cs, end];
}

/*设置收球轮速度*/
List<int> setSpeedData(int speed) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x47;
  int data = speed;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置收球轮速度:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置机器人速度*/
List<int> setRobotSpeedData(RobotSpeed speed) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x41;
  int data = speed.index + 1;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置机器人速度:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置机器人避障距离*/
List<int> setAvoidanceDistanceData(RobotAvoidanceDistance distance) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x48;
  int data = distance.index + 1;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置机器人避障距离:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置机器人收完50个球等待时间*/
List<int> setRobotWatiTimeData(RobotAvoidanceDistance distance) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x49;
  int data = distance.index + 1;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置机器收完50个球等待时间:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置区域*/
List<int> setAreaData(int area) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x39;
  int data = area;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置区域:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置角度*/
List<int> setAngleData(int angle) {
  int start = kDataFrameHeader;
  int length = 7;
  int cmd = 0x45;
  String dataString = angle.toRadixString(2).padLeft(16, '0');
  int data1 = binaryStringToDecimal(dataString.substring(0, 8));
  int data2 = binaryStringToDecimal(dataString.substring(8, 16));
  //int data = angle;
  int cs = start + length + cmd + data1 + data2;
  int end = kDataFrameFoot;
  print('设置角度:${[start, length, cmd, data1, data2, cs, end]}');
  return [start, length, cmd, data1, data2, cs, end];
}

List<int> manualFetchData(ManualFetchType type){
  List<int> _cmds = [
    0x20,
    0x32,
    0x33,
    0x34,
    0x36,
    0x42,
    0x43,
    0x44
  ];
  if(type.index  + 1> _cmds.length){
    return [];
  }
  int start = kDataFrameHeader;
  int length = 5;
  int cmd = _cmds[type.index];
  int cs = start + length + cmd;
  int end = kDataFrameFoot;
  print('主动获取:${[start, length, cmd, cs, end]}');
  return [start, length, cmd, cs, end];
}
