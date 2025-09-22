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

class _SelectCourtTypeControllerState extends State<SelectCourtTypeController> {
  bool isChoosed = true; // 是否选择了场地
  Color oneBGColor = Colors.grey;
  Color twoBGColor = Colors.grey;
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription = EventBus().stream.listen((event){
      if (event == kRobotConnectChange) {
         isChoosed = true;
         oneBGColor = Colors.grey;
         twoBGColor = Colors.grey;
         setState(() {});
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
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 44, right: 44, top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Constants.boldBaseTextWidget('', 16),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: 150),
                        Text(
                          "Choose court type",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.connectTextColor,
                            fontSize: 30,
                            height: 1.5,
                            fontFamily: 'SanFranciscoDisplay',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                oneBGColor =
                                    Constants.selectedModelOrangeBgColor;
                                twoBGColor = Colors.grey;
                                setState(() {});
                              },
                              child: Container(
                                child: Center(
                                  child: Constants.mediumWhiteTextWidget(
                                      '1号场', 20, Colors.white),
                                ),
                                height: 72,
                                color: oneBGColor,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 60),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            GestureDetector(
                              onTap: () {
                                twoBGColor =
                                    Constants.selectedModelOrangeBgColor;
                                oneBGColor = Colors.grey;
                                setState(() {});
                              },
                              child: Container(
                                child: Center(
                                  child: Constants.mediumWhiteTextWidget(
                                      '2号场', 20, Colors.white),
                                ),
                                height: 72,
                                color: twoBGColor,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 60),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (oneBGColor == Colors.grey &&
                          twoBGColor == Colors.grey) {
                        EasyLoading.showToast('please choose court');
                      } else {
                        if (oneBGColor == Constants.selectedModelOrangeBgColor) {
                          kBLEDevice_NewName = "seekbot2.0_1";
                        } else {
                          kBLEDevice_NewName = "seekbot2.0";
                        }
                        NavigatorUtil.pushWithContext(Routes.connect, context);
                        if (!mounted) return; // 防止在 dispose 后导航
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Constants.mediumWhiteTextWidget('Next', 20,
                            isChoosed ? Colors.white : Constants.grayTextColor),
                      ),
                      height: 72,
                      margin: EdgeInsets.only(left: 44, right: 44, top: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: isChoosed
                            ? Constants.selectedModelOrangeBgColor
                            : Constants.selectModelBgColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }
}
