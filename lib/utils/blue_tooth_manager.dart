import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tennis_robot/utils/data_base.dart';
import 'package:tennis_robot/utils/string_util.dart';

import '../constant/constants.dart';
import '../models/ble_model.dart';
import '../models/pickupBall_time.dart';
import 'ble_data_service.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import 'dialog.dart';
import 'navigator_util.dart';


Timer? repeatTimer;

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  final _ble = FlutterReactiveBle();

  // 蓝牙列表
  List<BLEModel> deviceList = [];

  // 已连接的蓝牙设备列表
  List<BLEModel>  get hasConnectedDeviceList  {
    return  this.deviceList.where((element) => element.hasConected == true).toList();
  }

  Function(TCPDataType type)? dataChange;
  Function(TCPDataType type)? deviceinfoChange; // 设备基本信息改变
  Function(String time)? workTimeChange; // 机器人工作时间改变
  Function(String blueName)? blueNameChange; // 机器人名字
  Function()? disConnect; // 机器人断链


  final ValueNotifier<int> deviceListLength = ValueNotifier(-1);

  // 已连接的设备数量
  final ValueNotifier<int> conectedDeviceCount = ValueNotifier(0);

  Stream<DiscoveredDevice>? _scanStream;

  /* 开始扫描 */
  Future<void> startScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      return;
    }

   if (Platform.isAndroid) {
      PermissionStatus locationPermission =
      await Permission.location.request();
      PermissionStatus bleScan =
      await Permission.bluetoothScan.request();
      PermissionStatus bleConnect =
      await Permission.bluetoothConnect.request();

      if (locationPermission == PermissionStatus.granted
          && bleScan == PermissionStatus.granted
          && bleConnect == PermissionStatus.granted){
         _scanStream = _ble.scanForDevices(withServices: [],
             scanMode: ScanMode.lowLatency );
        _scanStream!.listen((DiscoveredDevice event) {
            // 处理扫描到的蓝牙设备
           //print('扫描到的蓝牙设备event.name = ${event.name}');
           //&& event.name == kBLEDevice_NewName
           if (!hasDevice(event.id) ) {
             print('蓝牙名字${event.name}');
             this.deviceList.add(BLEModel(device: event));
             deviceListLength.value = this.deviceList.length;
             var model = this.deviceList.last;
             if (conectedDeviceCount.value == 0 && model.device.name == kBLEDevice_NewName) {
               // 已经连接的设备少于两个 则自动连接
               conectToDevice(this.deviceList.last);
               BluetoothManager().blueNameChange?.call(model.device.name);

             }
           }
        });
      }
   }
    else {
     _scanStream = _ble.scanForDevices(withServices: [],
         scanMode: ScanMode.lowLatency );
     _scanStream!.listen((DiscoveredDevice event) {
       // 处理扫描到的蓝牙设备
       //print('扫描到的蓝牙设备event.name = ${event.name}');
       //&& event.name == kBLEDevice_NewName
       if (!hasDevice(event.id) ) {
         print('蓝牙名字${event.name}');
         this.deviceList.add(BLEModel(device: event));
         deviceListLength.value = this.deviceList.length;
         var model = this.deviceList.last;
         if (conectedDeviceCount.value == 0 && model.device.name == kBLEDevice_NewName) {
           // 已经连接的设备少于两个 则自动连接
           conectToDevice(this.deviceList.last);
           BluetoothManager().blueNameChange?.call(model.device.name);

         }
       }
     });

   }
  }

  /*连接设备*/
  conectToDevice(BLEModel model) {

    if (model.hasConected == true) {
      // 已连接状态直接返回
      return;
    }
    //EasyLoading.show();
    _ble
        .connectToDevice(
        id: model.device.id, connectionTimeout: Duration(seconds: 10))
        .listen((ConnectionStateUpdate connectionStateUpdate) {
      print('connectionStateUpdate = ${connectionStateUpdate.connectionState}');
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // 连接成功主动发送心跳回复响应(获取准确电量)
        // BLESendUtil.heartBeatResponse();
        if(Platform.isAndroid){
          // 请求高优先级连接
          _ble.requestConnectionPriority(deviceId: model.device!.id, priority: ConnectionPriority.highPerformance);
        }
        // 连接设备数量+1
        conectedDeviceCount.value++;
        // 已连接
        model.hasConected = true;
        // 保存读写特征值
        late final notifyCharacteristic;
        if(model.device.name == kBLEDevice_NewName){
          // digital shoots
          notifyCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_270_SERVICE_UUID),
              characteristicId: Uuid.parse(kBLE_270_CHARACTERISTIC_NOTIFY_UUID),
              deviceId: model.device.id);
          model.notifyCharacteristic = notifyCharacteristic;
        }else{

        }
        // 确保是digital shoots
        if(model.device.name == kBLEDevice_NewName){
          final writerCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_270_SERVICE_UUID),
              characteristicId: Uuid.parse(kBLE_270_CHARACTERISTIC_WRITER_UUID),
              deviceId: model.device.id);
          model.writerCharacteristic = writerCharacteristic;
        }
        //  给digital shoots设备发送上线通知，不能给测速器发送
        if(model.device.name == kBLEDevice_NewName){

          // 每五秒发送一次心跳指令
          if(repeatTimer == null){
            repeatTimer = Timer.periodic(Duration(seconds: 5), (timer) {
              print('这将每隔5秒执行一次');

              writerDataToDevice(model, heartBeatData());
             // EasyLoading.showToast('心跳');
              updateRobotTodayUseTime();
              // 定时器执行完后的任务
              // 如果需要停止定时器，可以调用 timer.cancel()
            });
          }
        }
        // 连接成功弹窗
        EasyLoading.showSuccess('Bluetooth connection successful');
        // 监听数据
        _ble.subscribeToCharacteristic(notifyCharacteristic).listen((data) {
          print("deviceId =${model.device.id}---上报来的数据data = $data");
          // EasyLoading.showSuccess('蓝牙传输的数据');
          BluetoothDataParse.parseData(data,model);
        });
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
            EasyLoading.showError('disconected');
            // 取消定时器。停止计算工作时间
            if (repeatTimer != null) {
              repeatTimer?.cancel();
            }
            BluetoothManager().disConnect?.call();

        if(conectedDeviceCount.value > 0){
          conectedDeviceCount.value--;
        }
        // 失去连接
        model.hasConected = false;
        this.deviceList.remove(model);
        deviceListLength.value = this.deviceList.length;
      }
    });
  }

  /*发送数据*/
  Future<void> writerDataToDevice(BLEModel model, List<int> data) async {
    //  数据校验
    if (data == null || data.length == 0) {
      return;
    }
    // 确认蓝牙设备已连接 并保存对应的特征值
    if (model == null ||
        model.hasConected == null ||
        model.writerCharacteristic == null) {
      // TTToast.showErrorInfo('Please connect your device first');
      return;
    }
    print('999${model}');
    Future.delayed(Duration(milliseconds: 50),() async{
     return await _ble.writeCharacteristicWithResponse(model.writerCharacteristic!,
         value: data);

    });
  }

  /*判断是否已经被添加设备列表*/
  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
    this.deviceList.where((element) => element.device.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  // 更新机器人使用工作时间
  updateRobotTodayUseTime() async{
     final _list = await DataBaseHelper().getRobotWorkTimeData(kDataBasePickupBallTimeTableName);
     List<String> timeArray = [];
     var todayTime = StringUtil.currentTimeString();
     var todayRobotWorkSecond = 0;

     _list.forEach((element){
       timeArray.add(element.time);
       if (element.time == todayTime) { // 今日机器人的工作时间
         todayRobotWorkSecond = int.parse(element.pickupBallTime);
         BluetoothManager().workTimeChange?.call(element.pickupBallTime);
       }
     });
     todayRobotWorkSecond += 5;
     var model = PickupballTime(pickupBallTime: '${todayRobotWorkSecond}', time: todayTime);
     if(timeArray.contains(todayTime)) { // 数据库有当天的机器人工作时间数据
       DataBaseHelper().updateData(kDataBasePickupBallTimeTableName, model.toJson(), model.time);
     } else {
       DataBaseHelper().insertRobotWorkTimeData(kDataBasePickupBallTimeTableName, model);
     }
  }
}