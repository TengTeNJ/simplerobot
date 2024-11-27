import 'package:flutter/material.dart';
import 'package:tennis_robot/models/robot_data_model.dart';
import 'package:tennis_robot/setting/setting_option_adjust_view.dart';
import 'package:tennis_robot/utils/ble_send_util.dart';

import '../constant/constants.dart';

// 机器人速度设置
class SettingRollerSpeed extends StatefulWidget {
  const SettingRollerSpeed({super.key});

  @override
  State<SettingRollerSpeed> createState() => _SettingRollerSpeedState();
}

class _SettingRollerSpeedState extends State<SettingRollerSpeed> {
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
                    Text('   Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(248, 98, 21, 1),
                        fontSize: 16,
                      ),
                    ),

                    Constants.boldWhiteTextWidget('Roller Speed', 22),
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
                height: 124,
                width: 124,
                child: Image(
                  image: AssetImage('images/profile/roller_speed_setting_icon.png'),
                  fit: BoxFit.fill,
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 36),
                child: Center(
                  child:
                  Constants.boldWhiteTextWidget('You can adjust the speed of the robots wheel movement through different gears', 16),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 80),
                child: SettingOptionAdjustView(areaClick: (index){
                  print('${index}');
                  if (index == 0) {
                    BleSendUtil.setSpeed(RobotSpeed.slow); //低速
                  } else {
                    BleSendUtil.setSpeed(RobotSpeed.fast); //高速
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
