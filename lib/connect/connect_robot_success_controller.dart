import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/navigator_util.dart';

//机器人连接成功界面
class ConnectRobotSuccessController extends StatefulWidget {
  const ConnectRobotSuccessController({super.key});

  @override
  State<ConnectRobotSuccessController> createState() => _ConnectRobotSuccessControllerState();
}

class _ConnectRobotSuccessControllerState extends State<ConnectRobotSuccessController> {
  bool isConnected = true; // 是否连接上WiFi
  var currentWifiName = 'SeekerBot';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.darkControllerColor,
        body: SingleChildScrollView(
          child: ClipRect(
            child: Container(
              color: Constants.darkControllerColor,
              child: Column(
                children: [
                  Container(
                    height: 171,
                    width: 257,
                    margin: EdgeInsets.only(top: 167),
                    child: Image(
                      image: AssetImage('images/connect/robot.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 44, right: 44, top: 46),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Constants.customTextWidget('SUCCESS!', 18 , '#E96415', fontWeight:FontWeight.w700),
                        SizedBox(height: 5,),

                        Constants.customTextWidget('Bluetooth device connection \n successful', 18 , '#CCCCCC', fontWeight:FontWeight.w400,height:1.5 ),

                        SizedBox(height: 53,),
                        Constants.customTextWidget('Current Bluetooth Network', 18 , '#CCCCCC', fontWeight:FontWeight.w400),
                        SizedBox(height: 5,),

                        Constants.customTextWidget('Seekerbot', 18 , '#E96415', fontWeight:FontWeight.w400),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // NavigatorUtil.push(Routes.action);
                      NavigatorUtil.push(Routes.inputUserInfo);
                    },
                    child: Container(
                      child: Center(
                        child: Constants.mediumWhiteTextWidget(
                            'Start', 20,isConnected ? Colors.white : Constants.grayTextColor),
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
