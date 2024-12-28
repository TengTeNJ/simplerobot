import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/setting_option_adjust_view.dart';
import 'package:tennis_robot/utils/robot_manager.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../constant/constants.dart';
import '../models/robot_data_model.dart';
import '../utils/ble_send_util.dart';
import '../utils/navigator_util.dart';

// 避障距离
class SettingAvoidDistanceController extends StatefulWidget {
  const SettingAvoidDistanceController({super.key});

  @override
  State<SettingAvoidDistanceController> createState() => _SettingAvoidDistanceControllerState();
}

class _SettingAvoidDistanceControllerState extends State<SettingAvoidDistanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.darkControllerColor,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width:Constants.screenWidth(context),
          color: Constants.dialogBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 36,
                margin: EdgeInsets.only(right: 16, top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () {
                      NavigatorUtil.pop();
                    },
                      child: Text('   Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(248, 98, 21, 1),
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Constants.boldWhiteTextWidget('Safe Distance', 22),
                    Text('')
                  ],
                ),
              ),
              SizedBox(width: Constants.screenWidth(context),height: 1,),

              Container(
                margin: EdgeInsets.only(top: 20),
                width:  Constants.screenWidth(context),
                height: 1,
                color: Color.fromRGBO(86, 89, 101, 1),
              ),

              Container(
                margin: EdgeInsets.only(top: 60),
                height: 142,
                width: 82,
                child: Image(
                  image: AssetImage('images/profile/roller_avoid_distance_icon.png'),
                 // fit: BoxFit.fill,
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 36),
                child: Center(
                  child:
                  Constants.mediumWhiteTextWidget('You can adjust the '
                      'obstacle avoidance distance of the'
                      ' robot by'
                      ' changing the gears.', 16, Colors.white,maxLines: 2)
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 46,
                margin: EdgeInsets.only(top: 36),
                child: Center(
                    child:
                    Constants.boldWhiteTextWidget('This helps to'
                        ' prevent itfrom '
                        'getting stuck '
                        'on rough fences', 18)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 80),
                child: SettingOptionAdjustView(defaultIndex: 0,areaClick: (index){
                  print('${index}');
                  if (index == 0) {
                    BleSendUtil.setAvoidDistance(RobotAvoidanceDistance.near);// 近距离
                  } else {
                    BleSendUtil.setAvoidDistance(RobotAvoidanceDistance.far); // 远距离
                  }
                },),
              ),
            ],

          ),


        ),
      ),
    );
  }
}
