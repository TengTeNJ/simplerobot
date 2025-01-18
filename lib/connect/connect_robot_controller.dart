import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/route/routes.dart';
import 'package:tennis_robot/utils/blue_tooth_manager.dart';
import 'package:tennis_robot/utils/navigator_util.dart';
import 'package:tennis_robot/utils/robot_manager.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../utils/ble_send_util.dart';
import '../utils/ble_util.dart';
import '../utils/dialog.dart';
import '../utils/event_bus.dart';

class ConnectRobotController extends StatefulWidget {
  const ConnectRobotController({super.key});

  @override
  State<ConnectRobotController> createState() => _ConnectRobotControllerState();
}

class _ConnectRobotControllerState extends State<ConnectRobotController> {
  bool isConnected = true; // 是否连接上WiFi
  var currentWifiName = 'SeekerBot';

  late StreamSubscription subscription;
// 查询扫描到的机器人信息
  void queryRobotInfo() {
    var list = BluetoothManager().deviceList;
    for (var model in list) {
      if (model.device.name == kBLEDevice_NewName) {
        setState(() {
          currentWifiName = kBLEDevice_NewName;
        });
      }
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    BluetoothManager();
    // 扫描蓝牙设备

    Future.delayed(Duration(milliseconds: 1000),(){
      BleUtil.begainScan(context);
    });
    // 扫描蓝牙设备
    // BluetoothManager().startScan();
    subscription = EventBus().stream.listen((event){
      if (event == kRobotConnectChange) {
        print('机器人断连，蓝牙名字修改为默认名字');
        currentWifiName = 'SeekerBot';
        // 再查询一下机器人信息
        queryRobotInfo();
        setState(() {});
      }
    });

    // 遍历有没有扫描到机器人
    queryRobotInfo();

    BluetoothManager().blueNameChange = (blueName){
      setState(() {
        currentWifiName = blueName;
      });
    };

      // 连接界面系统蓝牙关闭
      BluetoothManager().disConnect = () {
        print('连接蓝牙断开');
        // app控制关机的不显示蓝牙弹窗
        setState(() {
          currentWifiName = 'SeekerBot';
        });
      };

    // 连接界面系统蓝牙打开
    BluetoothManager().openBlueTooth = () {
      queryRobotInfo();
    };
  }

  bool checkBluIsOpen() {
    if (FlutterReactiveBle().status == BleStatus.poweredOff) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    print('page 销毁');
  }

  @override
  Widget build(BuildContext context) {
    NavigatorUtil.init(context);

    return Scaffold(
        backgroundColor: Constants.darkControllerColor,
        body: SingleChildScrollView(
          child: ClipRect(
            child: Container(
              color: Constants.darkControllerColor,
              child: Column(
                children: [
                  Container(
                    height: 210,
                    width: 210,
                    margin: EdgeInsets.only(top: 107),
                    child: Image(
                      image: AssetImage('images/connect/robot_bluetooth.apng'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 44, right: 44, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Constants.boldBaseTextWidget('', 16),
                        SizedBox(
                          height: 10,
                        ),

                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: Constants.connectRobotText,
                                style: TextStyle(
                                  color: Constants.connectTextColor,
                                  fontSize: 18,
                                  height: 1.8,
                                  fontFamily: 'SanFranciscoDisplay',
                                  fontWeight: FontWeight.w500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '\n"${kBLEDevice_NewName}"',
                                    style: TextStyle(
                                      fontFamily: 'SanFranciscoDisplay',
                                      fontSize: 18,
                                      color: Color.fromRGBO(233, 86, 21, 1),
                                      height: 1.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ])),
                        SizedBox(height: 50),
                        Text(
                          "Current Bluetooth",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.connectTextColor,
                            fontSize: 18,
                            height: 1.5,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentWifiName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.grayTextColor,
                            fontSize: 18,
                            height: 1.8,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (checkBluIsOpen() == false) {
                        EasyLoading.showToast('please open bluetooth');
                        return;
                      }

                      if (currentWifiName != kBLEDevice_NewName) {
                        // 扫描连接失败弹窗
                        TTDialog.robotRobotConnectFailDialog(context,() async {
                          NavigatorUtil.pop();
                        });
                        // 扫描蓝牙设备
                       // BluetoothManager().startNewScan();
                      } else {
                        var list = BluetoothManager().deviceList;
                        for (var model in list) {
                          if (model.device.name == kBLEDevice_NewName) {
                            print('开始连接机器人');
                            BluetoothManager().conectToDevice(model);
                          }
                        }

                        NavigatorUtil.push(Routes.connectSuccess);
                      }

                    },
                    child: Container(
                      child: Center(
                        child: Constants.mediumWhiteTextWidget(
                            'Connect', 20,isConnected ? Colors.white : Constants.grayTextColor),
                      ),
                      height: 72,
                      margin: EdgeInsets.only(left: 44, right: 44, top: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: isConnected ? Constants.selectedModelOrangeBgColor : Constants.selectModelBgColor ,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        )
    );
  }
}
