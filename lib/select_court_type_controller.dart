import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tennis_robot/route/routes.dart';
import 'package:tennis_robot/utils/event_bus.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import 'constant/constants.dart';

class SelectCourtTypeController extends StatefulWidget {
  const SelectCourtTypeController({super.key});

  @override
  State<SelectCourtTypeController> createState() =>
      _SelectCourtTypeControllerState();
}

/// 选择机器人类型（1.0 or 2.0）
class _SelectCourtTypeControllerState extends State<SelectCourtTypeController> {
  bool isChoosedOneRobot = false; // 是否选择了机器人1.0
  bool isChoosedTwoRobot = false; // 是否选择了机器人2.0

  Color oneBGColor = Colors.grey;
  Color twoBGColor = Colors.grey;
  late StreamSubscription subscription;

  static Color unSelectedBgColor = Color.fromRGBO(46, 47, 49, 1.0);
  static Color selectedBgColor = Color.fromRGBO(86, 45, 28, 1.0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription = EventBus().stream.listen((event){
      if (event == kRobotConnectChange) {
        isChoosedOneRobot = true;
        oneBGColor = Colors.grey;
        twoBGColor = Colors.grey;
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    NavigatorUtil.init(context);
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      body: WillPopScope(child: SingleChildScrollView(
        child: ClipRect(
          child: Container(
            color: Constants.darkControllerColor,
            child: Column(
              children: [
                Container(
                  height: 171,
                  width: 257,
                  margin: EdgeInsets.only(top: 105),
                  child: Image(
                    image: AssetImage('images/connect/connect_success_robot.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 44,),

                Constants.regularWhiteTextWidget("Please select the Seekerbot mode", 18, Constants.connectTextColor),
                SizedBox(height: 49,),
                GestureDetector(
                  onTap: () {
                    isChoosedOneRobot = true;
                    isChoosedTwoRobot = false;
                    kBLEDevice_NewName = "seekbot1.0";
                    setState(() {});
                  },
                  child: Container(
                    child: Center(
                      child: Constants.mediumWhiteTextWidget(
                          'SEEKERBOT 1.0', 18,isChoosedOneRobot ?
                      Color.fromRGBO(248, 98, 21, 1.0) : Constants.grayTextColor),
                    ),
                    height: 90,
                    width: Constants.screenWidth(context) - 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isChoosedOneRobot ? selectedBgColor : unSelectedBgColor ,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    isChoosedTwoRobot = true;
                    isChoosedOneRobot = false;
                    kBLEDevice_NewName = "seekbot2.0";
                    setState(() {});
                  },
                  child: Container(
                    child: Center(
                      child: Constants.mediumWhiteTextWidget(
                          'SEEKERBOT 2.0', 18,isChoosedTwoRobot ?
                      Color.fromRGBO(248, 98, 21, 1.0) : Constants.grayTextColor),
                    ),
                    width: Constants.screenWidth(context) - 66,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isChoosedTwoRobot ? selectedBgColor : unSelectedBgColor ,
                    ),
                  ),
                ),


                GestureDetector(
                  onTap: () {
                    if (isChoosedOneRobot || isChoosedTwoRobot) {
                      NavigatorUtil.pushReplacementNamed(Routes.connect);
                    }
                  },
                  child: Container(
                    child: Center(
                      child: Constants.mediumWhiteTextWidget(
                          'Continue', 20,(isChoosedOneRobot || isChoosedTwoRobot) ? Colors.white : Constants.grayTextColor),
                    ),
                    height: 72,
                    margin: EdgeInsets.only(left: 44, right: 44, top: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: (isChoosedOneRobot || isChoosedTwoRobot) ? Constants.selectedModelOrangeBgColor : Constants.selectModelBgColor ,
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),onWillPop: (){
        return Future.value(false);
      },
      ),
    );

  }

}
