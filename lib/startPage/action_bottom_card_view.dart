
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/ble_send_util.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/dialog.dart';
import '../utils/event_bus.dart';
import '../utils/robot_manager.dart';
class ActionBottomCardView extends StatefulWidget {
  int index = 0;
  ActionBottomCardView({ required this.index});
  @override
  State<ActionBottomCardView> createState() => _ActionBottomCardViewState();
}

class _ActionBottomCardViewState extends State<ActionBottomCardView> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          child:  GestureDetector(onTap: (){
            if (widget.index == 1) {
              BluetoothManager().clickIndex?.call(1);


             // TTDialog.robotPowerOff(context, () async{
              //   NavigatorUtil.pop();
              //   BleSendUtil.setRobotPoweroff();
              // });
            } else {
              BluetoothManager().clickIndex?.call(0);
            }

          },
            child:Image(
              width:132,
              height: 132,
              image: AssetImage( widget.index == 0 ? 'images/home/robot_start.apng' : 'images/home/robot_poweroff.apng'),
            ),
            
          ),
        ),
        widget.index == 1 ?
        Constants.regularWhiteTextWidget('Power Off', 18, Color.fromRGBO(194, 35, 38, 1)):
        Container()
      ],

    );
  }
}
