import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/setting/setting_avoid_distance_controller.dart';
import 'package:tennis_robot/setting/setting_ball_type_controller.dart';
import 'package:tennis_robot/utils/navigator_util.dart';
import 'package:tennis_robot/route/routes.dart';

import '../setting/setting_roller_speed.dart';

class ProfileListView extends StatefulWidget {
  ProfileListView({this.assetPath, required this.title});
  String? assetPath;
  String title;

  @override
  State<ProfileListView> createState() => _ProfileListViewState();
}

class _ProfileListViewState extends State<ProfileListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) / 2 - 32,
      height: 136,
      decoration: BoxDecoration(
        color: Constants.dialogBgColor,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // GestureDetector(onTap: (){
          //   NavigatorUtil.push(Routes.connect);
          // },child:
          //   ,)
          //
          GestureDetector(onTap: (){
            if(widget.assetPath == 'images/profile/setting_roller_speed.png') {
              NavigatorUtil.present(SettingRollerSpeed());
            } else if(widget.assetPath == 'images/profile/setting_distance.png') {
              NavigatorUtil.present(SettingAvoidDistanceController());
            } else if(widget.assetPath == 'images/profile/setting_ball_type.png') {
              NavigatorUtil.present(SettingBallTypeController());
            }
          },
                child: Padding(
                 padding: EdgeInsets.only(top: 27),
                 child:  Image(
                 image: AssetImage(widget.assetPath ?? ''),
                 width: 50,
                 height: 50,
    ),
    ),

    ),
          SizedBox(height: 16),
          Constants.mediumWhiteTextWidget(widget.title, 16, Colors.white),
          // Text(widget.title,
          //  style: TextStyle(
          //         fontFamily: 'SanFranciscoDisplay',
          //         fontSize: 16, color: Colors.white, height: 0.8),
          //  ),
        ],
      ),
    );
  }
}
