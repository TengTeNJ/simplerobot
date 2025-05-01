
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tennis_robot/utils/ble_send_util.dart';
import 'package:tennis_robot/utils/toast.dart';

import '../models/ble_model.dart';
import 'blue_tooth_manager.dart';

class ControlTimeOutUtil{
  int _retryTimes = 0;
  Completer<bool> completer = Completer();
  List<int> ongoingData = [];
  ValueNotifier<bool> controling = ValueNotifier<bool>(false);
  //bool controling = false; // 是否正在控制 而且没有返回
  Timer? timeOutTimer;
  int controlBoard = -1; //  控制的灯板 超时重发的不记录
  int _controlLedId = 1; // 控制等的索引 最大为255
  static final ControlTimeOutUtil _instance = ControlTimeOutUtil._internal();
  factory ControlTimeOutUtil() {
    return _instance;
  }
  ControlTimeOutUtil._internal();
  int  get retryTimes => _retryTimes;
  int  get controlLedId => _controlLedId;

/*改变重试的次数*/
  set retryTimes(int times){
    _retryTimes = times;
    if(_retryTimes > 10){
      TTToast.showErrorInfo('The timeout limit has been reached. Please check the device.');
      ControlTimeOutUtil().controlLedId ++;
      print('超时次数到达上限===${ControlTimeOutUtil().controlLedId}');
      this.completer.complete(true);
      reset();
    }else{
      final model = BluetoothManager()
          .hasConnectedDeviceList
          .firstWhere((element) => element.device.name == 'seekbot2.0');
      BluetoothManager().writerDataToDevice(model, ControlTimeOutUtil().ongoingData);

      begainTimer();
    }
  }
  set controlLedId(int idValue){
    if(idValue > 255){
      idValue = 1;
    }
    _controlLedId = idValue;
  }
/*开始超时监听*/
  begainTimer(){
    if( this.timeOutTimer != null){
      this.timeOutTimer!.cancel();
      this.timeOutTimer = null;
    }
    this.timeOutTimer =  Timer(Duration(milliseconds: 300), (){
      this.retryTimes ++;
      print('超时${retryTimes}次---${controlLedId}');
    });
  }

  /*重置超时监听*/
  reset(){
    ControlTimeOutUtil().completer = Completer<bool>();
    if( this.timeOutTimer != null){
      this.timeOutTimer!.cancel();
      this.timeOutTimer = null;
    }
    this._retryTimes = 0;
    this.ongoingData.clear();
    this.controling.value = false;
    ControlTimeOutUtil().controling.removeListener(() {});
  }
}







