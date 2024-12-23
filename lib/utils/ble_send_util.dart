import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/blue_tooth_manager.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';
import '../models/ble_model.dart';
import '../models/robot_data_model.dart';

class BleSendUtil {
  // 设置机器人角度
  static setRobotAngle(int angle) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), setAngleData(angle));
  }

  // 设置机器人模式
  static setRobotMode(RobotMode mode) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), changeRobotMode(mode));
  }

  // 设置收球轮速度
  static setRobotCollectingWheelSpeed(int mode) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), setSpeedData(mode));
  }

  // 设置机器人速度
  static setSpeed(RobotSpeed speed) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
   BluetoothManager().writerDataToDevice(getWriterDevice(), setRobotSpeedData(speed));
  }

  // 设置机器人避障距离
  static setAvoidDistance(RobotAvoidanceDistance distance) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), setAvoidanceDistanceData(distance));
  }

  // 设置机器人等待时间
  static setWaitTime(RobotAvoidanceDistance distance) {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), setRobotWatiTimeData(distance));
  }

  static BLEModel getWriterDevice() {
    final model = BluetoothManager()
        .hasConnectedDeviceList
        .firstWhere((element) => element.device.name == kBLEDevice_NewName);
    return model;
  }
}