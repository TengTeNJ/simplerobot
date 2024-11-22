import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/route/routes.dart';
import 'package:tennis_robot/utils/blue_tooth_manager.dart';
import 'package:tennis_robot/utils/navigator_util.dart';
import 'package:tennis_robot/utils/robot_manager.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../utils/ble_send_util.dart';
// import 'dart:html';
class ConnectRobotController extends StatefulWidget {
  const ConnectRobotController({super.key});

  @override
  State<ConnectRobotController> createState() => _ConnectRobotControllerState();
}

class _ConnectRobotControllerState extends State<ConnectRobotController> {
  bool isConnected = true; // 是否连接上WiFi
  var currentWifiName = 'Potent Robot';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWifiName();
    // 扫描蓝牙设备
    BluetoothManager().startScan();
    setAngleData(35.toInt());

    Future.delayed(Duration(milliseconds: 3000), () {
      var list = BluetoothManager().deviceList;
      print('扫描到的蓝牙列表${list}');
      if (list.length >0) {
      //  BluetoothManager().conectToDevice(list.last);
        // var model = list.last;
         setState(() {
           for (var model in list) {
             if (model.device.name == kBLEDevice_NewName) {
               currentWifiName = model.device.name;
             }
           }

         });
      }
    });


  }

  void getWifiName() async {
    final info = NetworkInfo();
    final wifiName = await info.getWifiName();
    print('66666${wifiName}');
    setState(() {
      if(wifiName != null){
        currentWifiName = wifiName!;
        if (currentWifiName.contains('potent') ){ // 机器人WiFi的名字包含seek
            isConnected = true;
        }
      }
    });
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
                    height: 215,
                    width: 278,
                    margin: EdgeInsets.only(top: 167),
                    child: Image(
                      image: AssetImage('images/connect/robot.png'),
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
                                    text: '   "Seekerbot"',
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
                          "Current Bluetooth Network",
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
                            color: Constants.connectTextColor,
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
                      var list = BluetoothManager().deviceList;
                      for (var model in list) {
                        if (model.device.name == kBLEDevice_NewName) {
                          BluetoothManager().conectToDevice(model);
                        }
                      }
                      RobotManager().startTCPConnect();
                      // 在需要用到的页面进行数据监听 格式如下，根据不同的TCPDataType类型和自己的需求进行页面刷新
                      RobotManager().dataChange = (TCPDataType type) {
                        if (type == TCPDataType.speed) {
                          print('speed123 ${RobotManager().dataModel.speed}');
                        } else if(type == TCPDataType.deviceInfo) {
                          print('deviceInfo123 ${RobotManager().dataModel.speed}');
                        }
                      };
                      NavigatorUtil.push(Routes.action);
                    },
                    child: Container(
                      child: Center(
                        child: Constants.mediumWhiteTextWidget(
                            'Add Robot', 20,isConnected ? Colors.white : Constants.grayTextColor),
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
