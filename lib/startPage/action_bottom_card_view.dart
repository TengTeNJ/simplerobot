import 'package:flutter/material.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import '../route/routes.dart';
import '../utils/ble_send_util.dart';
import '../utils/dialog.dart';
class ActionBottomCardView extends StatefulWidget {
  int index = 0;
  ActionBottomCardView({ required this.index});
  @override
  State<ActionBottomCardView> createState() => _ActionBottomCardViewState();
}

class _ActionBottomCardViewState extends State<ActionBottomCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:  Image(
            width:118,
            height: 282,
            image: AssetImage('images/connect/left_mask.png'),
          ),),

          GestureDetector(onTap: (){
             if (widget.index == 1) {
               TTDialog.robotPowerOff(context, () async{
                 NavigatorUtil.pop();
                 BleSendUtil.setRobotPoweroff();
               });
             } else {
               NavigatorUtil.push(Routes.pickMode);
             }

          },
            child:Image(
              width:126,
              height: 126,
              image: AssetImage( widget.index == 0 ? 'images/home/robot_start.apng' : 'images/home/robot_poweroff.apng'),
            ),
          ),



          Expanded(child:  Image(
            width:118,
            height: 282,
            image: AssetImage('images/connect/right_mask.png'),
          ),),
        ],
      ),

    );
  }
}
