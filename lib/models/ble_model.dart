import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEModel  {
  DiscoveredDevice device; // 蓝牙设备信息
  bool? hasConected; // 连接状态
  QualifiedCharacteristic? notifyCharacteristic; // notify特征值
  QualifiedCharacteristic? writerCharacteristic; // writer特征值
  BLEModel({required  this.device,this.hasConected = false,this.notifyCharacteristic,this.writerCharacteristic}) ;
}