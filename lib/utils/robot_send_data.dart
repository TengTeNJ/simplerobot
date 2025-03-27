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
  int data = mode.index + 1;
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
List<int> setRobotWatiTimeData(RobotResetGap distance) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x49;
  int data = distance.index;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置机器收完50个球等待时间:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

/*设置机器人关机*/
List<int> setRobotPowerData() {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x50;
  int data = 0;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置关机:${[start, length, cmd, data, cs, end]}');
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

/*设置电子围栏围栏*/
List<int> setElectronicFenceData(int direction,int angle) {
  int start = kDataFrameHeader;
  int length = 8;
  int cmd = 0x52;
  int data = direction;
  String dataString = angle.toRadixString(2).padLeft(16, '0');
  int data1 = binaryStringToDecimal(dataString.substring(0, 8));
  int data2 = binaryStringToDecimal(dataString.substring(8, 16));
  //int data = angle;
  int cs = start + length + cmd + data +  data1 + data2;
  int end = kDataFrameFoot;
  print('设置电子围栏:${[start, length, cmd, data,data1, data2, cs, end]}');
  return [start, length, cmd, data, data1, data2, cs, end];
}

/*APP发送导航指令*/
List<int> setRobotBeginNavigationData(int type,int direction,int angle) {
  int start = kDataFrameHeader;
  int length = 9;
  int cmd = 0x52;
  int typeData = type;
  int data = direction;
  String dataString = angle.toRadixString(2).padLeft(16, '0');
  int data1 = binaryStringToDecimal(dataString.substring(0, 8));
  int data2 = binaryStringToDecimal(dataString.substring(8, 16));
  //int data = angle;
  int cs = start + length + cmd + typeData + data +  data1 + data2;
  int end = kDataFrameFoot;
  print('APP发送导航指令:${[start, length, cmd, typeData,data,data1, data2, cs, end]}');
  return [start, length, cmd, typeData,data, data1, data2, cs, end];
}


/*APP 发送导航结束指令*/ // 1 到达原点  2 区域位置到达
List<int> setRobotNavigationEndData(int type) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x54;
  int data = type;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置关机:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

//设置机器人开始 捡球  暂停捡球（0 stop 1 start）
List<int> setRobotStartPickData(int state) {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x56;
  int data = state;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('设置机器人开始 捡球:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
}

//发送重置指令（机器人退出导航等相关程序，app 退出鹰眼界面时调用））
List<int> setRobotResetData() {
  int start = kDataFrameHeader;
  int length = 6;
  int cmd = 0x59;
  int data = 0;
  int cs = start + length + cmd + data;
  int end = kDataFrameFoot;
  print('发送重置指令:${[start, length, cmd, data, cs, end]}');
  return [start, length, cmd, data, cs, end];
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
