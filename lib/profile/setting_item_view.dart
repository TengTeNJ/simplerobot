import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/models/language_model.dart';
import 'package:tennis_robot/models/setting_model.dart';
import 'package:tennis_robot/setting/setting_avoid_distance_controller.dart';
import 'package:tennis_robot/setting/setting_reset_gap_controller.dart';

import '../UserInfo/user_profile_controller.dart';
import '../fault/fault_info_controller.dart';
import '../setting/new_setting_ball_type_controller.dart';
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
         if (widget.model.title == '${Provider.of<LanguageModel>(context,listen: false).getText("收球类型")}') {
          // NavigatorUtil.present(SettingBallTypeController());
         NavigatorUtil.present(NewSettingBallTypeController());

         } else if (widget.model.title =='${Provider.of<LanguageModel>(context,listen: false).getText("车轮速度")}'){
           NavigatorUtil.present(SettingRollerSpeed());
         } else if (widget.model.title == '${Provider.of<LanguageModel>(context,listen: false).getText("个人资料")}') {
           NavigatorUtil.present(UserProfileController());
         } else if (widget.model.title == '${Provider.of<LanguageModel>(context,listen: false).getText("故障引导")}') {
           NavigatorUtil.present(FaultInfoController());
         } else {
           NavigatorUtil.present(SettingResetGapController());

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
              margin: EdgeInsets.only(left: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      //margin: EdgeInsets.only(left: 20),
                      child: Image(
                        image: AssetImage('${widget.model.imageAsset}'),
                        width: 34,
                        height:34,)
                  ),

                  SizedBox(width: 24,),
                  Constants.mediumWhiteTextWidget('${widget.model.title}', 18, Colors.white),
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
