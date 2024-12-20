import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/models/setting_model.dart';

import '../UserInfo/user_profile_controller.dart';
import '../fault/fault_info_controller.dart';
import '../setting/setting_ball_type_controller.dart';
import '../setting/setting_roller_speed.dart';
import '../utils/navigator_util.dart';

class SettingItemView extends StatefulWidget {
  SettingModel model;

  SettingItemView({required this.model});
  @override
  State<SettingItemView> createState() => _SettingItemViewState();
}

class _SettingItemViewState extends State<SettingItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     // behavior: HitTestBehavior.opaque,
      onTap: (){
         if (widget.model.title == 'Ball Type') {
           NavigatorUtil.present(SettingBallTypeController());
         } else if (widget.model.title =='Roller Speed'){
           NavigatorUtil.present(SettingRollerSpeed());
         } else if (widget.model.title == 'Profile') {
           NavigatorUtil.present(UserProfileController());
         } else {
           NavigatorUtil.present(FaultInfoController());
         }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.dialogBgColor,
          borderRadius: BorderRadius.circular(5),),
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      //margin: EdgeInsets.only(left: 20),
                      child: Image(
                        image: AssetImage('${widget.model.imageAsset}'),
                        width: 28,
                        height:28,)
                  ),

                  SizedBox(width: 20,),
                  Constants.mediumWhiteTextWidget('${widget.model.title}', 16, Colors.white),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 20),
                child: Image(
                  image: AssetImage('images/profile/setting_arrow.png'),
                  width: 7,
                  height:13,)
            ),
          ],

        ),

      ),
    );
  }
}
