import 'dart:async';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/route/routes.dart';
import 'package:tennis_robot/utils/blue_tooth_manager.dart';
import 'package:tennis_robot/utils/navigator_util.dart';
import 'package:tennis_robot/utils/robot_manager.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../utils/ble_send_util.dart';
import '../utils/dialog.dart';
import '../utils/event_bus.dart';
// import 'dart:html';
class ConnectRobotController extends StatefulWidget {
  const ConnectRobotController({super.key});

  @override
  State<ConnectRobotController> createState() => _ConnectRobotControllerState();
}

class _ConnectRobotControllerState extends State<ConnectRobotController> {
  bool isConnected = true; // 是否连接上WiFi
  var currentWifiName = 'SeekerBot';

  late StreamSubscription subscription;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    // 扫描蓝牙设备
    BluetoothManager().startScan();
    subscription = EventBus().stream.listen((event){
      if (event == kRobotConnectChange) {
        print('机器人断连，蓝牙名字修改为默认名字');
        currentWifiName = 'SeekerBot';
        setState(() {});
      }
    });


    // setAngleData(35.toInt());

    // Future.delayed(Duration(milliseconds: 3000), () {
    //   var list = BluetoothManager().deviceList;
    //   print('扫描到的蓝牙列表${list}');
    //   if (list.length >0) {
    //      setState(() {
    //        for (var model in list) {
    //          if (model.device.name == kBLEDevice_NewName) {
    //            currentWifiName = model.device.name;
    //          }
    //        }
    //
    //      });
    //   }
    // });

    BluetoothManager().blueNameChange = (blueName){
      setState(() {
        currentWifiName = blueName;
      });
    };


    // var isConnected = true;
    // Future.delayed(Duration(milliseconds: 300),() {
    //   if (isConnected) {
    //     NavigatorUtil.push(Routes.action);
    //     NavigatorUtil.push(Routes.pickMode);
    //   }
    // });


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
                                    text: '\n"Seekerbot"',
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

                      if (currentWifiName != kBLEDevice_NewName) {
                        // 扫描连接失败弹窗
                        TTDialog.robotRobotConnectFailDialog(context,() async {
                          NavigatorUtil.pop();
                        });
                        // 扫描蓝牙设备
                        BluetoothManager().startScan();
                      } else {
                        var list = BluetoothManager().deviceList;
                        for (var model in list) {
                          if (model.device.name == kBLEDevice_NewName) {
                            BluetoothManager().conectToDevice(model);
                          }
                        }

                        NavigatorUtil.push(Routes.connectSuccess);
                      }
                      // NavigatorUtil.push(Routes.connectSuccess);

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
