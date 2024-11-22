import 'dart:async';
import 'package:tennis_robot/models/ball_model.dart';
import 'package:tennis_robot/models/robot_data_model.dart';
import 'package:tennis_robot/utils/event_bus.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';
import 'package:tennis_robot/utils/string_util.dart';
import 'package:tennis_robot/utils/tcp_util.dart';
import '../constant/constants.dart';

enum TCPDataType {
  none,
  deviceInfo,
  workStatu,
  warnInfo,
  errorInfo,
  mode,
  finishOneFlag,
  area,
  speed,
  coordinate,
  ballsInView
}

class RobotManager {
  StreamSubscription? _subscription;
  TcpUtil? _utpUtil;

  // 机器人数据模型
  RobotDataModel dataModel = RobotDataModel();

  /*RobotManager设置为单例模型*/
  static RobotManager _instance = RobotManager._sharedInstance();

  factory RobotManager() {
    return _instance;
  }

  RobotManager._sharedInstance();

  // 在需要用到的页面进行数据监听 格式如下，根据不同的TCPDataType类型和自己的需求进行页面刷新
  /*
  *  RobotManager().dataChange = (TCPDataType type)  {

  };
  * */
  Function(TCPDataType type)? dataChange;

  // 数据改变时内部调用
  _triggerCallback({TCPDataType type = TCPDataType.none}) {
    dataChange?.call(type);
  }

  /*开始TCP连接*/
  startTCPConnect() async {
    _utpUtil = TcpUtil.begainTCPSocket();
    _subscription = EventBus().stream.listen((onData) {
      print('onData.runtimeType = ${onData.runtimeType}');
      if (onData.runtimeType.toString().toUpperCase().contains('MAP')) {
        String key = onData['key'];
        if (key != null && key == kTCPDataListen) {
          print('监听到了TCP数据');
          // 获取传递过来的数据数据
          List<int> _data = onData['value'];
          // 解析数据
          parseData(_data);
        }
      }
    });
  }

  /*关闭socket连接*/
  closeSocket() {
    _subscription?.cancel();
    _utpUtil?.closeTCPClient();
  }

  /*设置机器人模式*/
  setRobotMode(RobotMode mode) {
    List<int> data = changeRobotMode(mode);
    // _utpUtil?.sendData(data.toString());
    _utpUtil?.sendListData(data);
  }

  /*设置机器人区域*/
  setRobotArea(int area) {
    List<int> data = setAreaData(area);
    // _utpUtil?.sendData(data.toString());
    _utpUtil?.sendListData(data);
  }

  /*设置机器人速度*/
  setRobotSpeed(int speed) {
    List<int> data = setAreaData(speed);
    _utpUtil?.sendData(data.toString());
  }

  /*清零*/
  clearCount() {
    List<int> data = clearCountData();
    _utpUtil?.sendData(data.toString());
  }

  /*设置机器人移动角度*/
  setRobotAngle(int angle) {
    List<int> data = setAngleData(angle);
    _utpUtil?.sendListData(data);
  }

  /*主动请求某个数据*/
  manualFetch(ManualFetchType type) {
    List<int> data = manualFetchData(type);
    //_utpUtil?.sendData(data.toString());
    //_utpUtil?.sendListData(data);
  }
}

/*数据拆分*/
List<List<int>> splitData(List<int> _data) {
  int a = kDataFrameHeader;
  List<List<int>> result = [];
  int start = 0;
  while (true) {
    int index = _data.indexOf(a, start);
    if (index == -1) break;
    List<int> subList = _data.sublist(start, index);
    result.add(subList);
    start = index + 1;
  }
  if (start < _data.length) {
    List<int> subList = _data.sublist(start);
    result.add(subList);
  }
  return result;
}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;

parseData(List<int> data) {
  if (data.contains(kDataFrameHeader)) {
    List<List<int>> _datas = splitData(data);
    _datas.forEach((element) {
      if (element == null || element.length == 0) {
        // 空数组
        // print('问题数据${element}');
      } else {
        // 先获取长度
        int length = element[0] - 1; // 获取长度 去掉了帧头
        if (length != element.length) {
          // 说明不是完整数据
          bleNotAllData.addAll(element);
          if (bleNotAllData[0] - 1 == bleNotAllData.length) {
            print('组包1----${element}');
            handleData(bleNotAllData);
            isNew = true;
            bleNotAllData.clear();
          } else {
            isNew = false;
            Future.delayed(Duration(milliseconds: 10), () {
              if (!isNew) {
                bleNotAllData.clear();
              }
            });
          }
        } else {
          handleData(element);
        }
      }
    });
  } else {
    bleNotAllData.addAll(data);
    if (bleNotAllData[0] - 1 == bleNotAllData.length) {
      print('组包2----${data}');
      handleData(bleNotAllData);
      isNew = true;
      bleNotAllData.clear();
    } else {
      isNew = false;
      Future.delayed(Duration(milliseconds: 10), () {
        if (!isNew) {
          bleNotAllData.clear();
        }
      });
    }
    print('蓝牙设备响应数据不合法=${data}');
  }
}

handleData(List<int> element) {
  int cmd = element[1];
  switch (cmd) {
    case ResponseCMDType.finishOneFlag:
      RobotManager()._triggerCallback(type: TCPDataType.finishOneFlag);
      print('捡球成功');

    case ResponseCMDType.deviceInfo:
      int switch_data = element[3]; // 开关机
      int power_data = element[2]; // 电量
      // 开关机
      RobotManager().dataModel.powerOn = switch_data == 1;
      print('开关机=======${switch_data}');
      // 电量
      RobotManager().dataModel.powerValue = power_data;
      print('电量=======${power_data}');
      RobotManager()._triggerCallback(type: TCPDataType.deviceInfo);
      break;
    case ResponseCMDType.workStatu:
      int statu_data = element[2];
      RobotManager().dataModel.statu = [
        RobotStatu.standby,
        RobotStatu.ready,
        RobotStatu.work,
        RobotStatu.error
      ][statu_data];
      print('机器人工作状态=======${statu_data}');
      RobotManager()._triggerCallback(type: TCPDataType.workStatu);
      break;
    case ResponseCMDType.mode:
      int mode_data = element[2];
      RobotManager().dataModel.mode =
          [RobotMode.rest, RobotMode.training, RobotMode.remote][mode_data];
      print('机器人模式=======${mode_data}');
      RobotManager()._triggerCallback(type: TCPDataType.mode);
      break;
    case ResponseCMDType.speed:
      int speed_data = element[2];
      RobotManager().dataModel.speed = speed_data;
      print('速度=======${speed_data}');
      RobotManager()._triggerCallback(type: TCPDataType.speed);
      break;
    case ResponseCMDType.warnInfo:
      int warn_data = element[2];
      RobotManager().dataModel.warnStatu = warn_data;
      print('告警信息=======${warn_data}');
      RobotManager()._triggerCallback(type: TCPDataType.warnInfo);
      break;
    case ResponseCMDType.errorInfo:
      int error_data = element[2];
      RobotManager().dataModel.errorStatu = error_data;
      print('故障信息=======${error_data}');
      RobotManager()._triggerCallback(type: TCPDataType.errorInfo);
      break;
  }
}
