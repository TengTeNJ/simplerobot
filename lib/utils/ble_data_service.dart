import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/models/ble_model.dart';
import 'package:tennis_robot/utils/robot_manager.dart';

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

class ResponseCMDType {
  static const int none = 0x00; // 默认无
  static const int deviceInfo = 0x20; // 设备信息，包含开机状态、电量等
  static const int workStatu = 0x32; // 机器人状态 0x00 待机\暂停0x01 就绪 0x02 工作中 0x03 故障
  static const int warnInfo = 0x33; // 机器人告警信息
  static const int errorInfo = 0x34; // 机器人故障信息
  static const int mode = 0x36; // 机器人模式
  static const int finishOneFlag = 0x37; // 机器人捡球上报，每捡到一个球 上报一次
  static const int area = 0x40; // 机器人区域
  static const int speed = 0x42; // 机器人速度
  static const int coordinate = 0x43; // 机器人坐标
  static const int ballsInView = 0x44; // 机器人视野的所有数据
}

List<int> bleNotAllData1 = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
// 蓝牙数据解析类
class BluetoothDataParse {
  // 数据解析
  static parseData(List<int> data, BLEModel model) {
    if (data.isEmpty) {
      return;
    }

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
            bleNotAllData1.addAll(element);
            if (bleNotAllData1[0] - 1 == bleNotAllData1.length) {
              print('组包1----${element}');
              handleData(bleNotAllData1);
              isNew = true;
              bleNotAllData1.clear();
            } else {
              isNew = false;
              Future.delayed(Duration(milliseconds: 10), () {
                if (!isNew) {
                  bleNotAllData1.clear();
                }
              });
            }
          } else {
            handleData(element);
          }
        }
      });
    } else {
      bleNotAllData1.addAll(data);
      if (bleNotAllData[0] - 1 == bleNotAllData1.length) {
        print('组包2----${data}');
        handleData(bleNotAllData1);
        isNew = true;
        bleNotAllData1.clear();
      } else {
        isNew = false;
        Future.delayed(Duration(milliseconds: 10), () {
          if (!isNew) {
            bleNotAllData1.clear();
          }
        });
      }
      print('蓝牙设备响应数据不合法=${data}');
    }
  }
}




