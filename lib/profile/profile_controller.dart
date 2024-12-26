import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/profile/setting_list_view.dart';
import '../models/setting_model.dart';
import '../utils/navigator_util.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  List<SettingModel> data = [
    SettingModel('images/profile/setting_ball_type.png','Ball Type'),
    SettingModel('images/profile/setting_roller_speed.png','Roller Speed'),
    SettingModel('images/profile/setting_reset_gap.png','Reset Gap'),
    SettingModel('images/profile/setting_profile.png','Profile'),
    SettingModel('images/profile/setting_fault.png','Fault'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.darkControllerColor,
         child: Column(
           children: [
             Container(
               width: Constants.screenWidth(context),
               margin: EdgeInsets.only(top: 55,left: 24),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   GestureDetector(onTap: (){
                    NavigatorUtil.pop();
                     },
                     child: Container(
                     //  padding: EdgeInsets.all(12.0),
                       padding: EdgeInsets.only(left: 0,top: 12,bottom: 12,right: 24),
                       color:  Constants.darkControllerColor,
                       width: 48,
                       height: 48,
                       child: Image(
                           width:24,
                           height: 24,
                           image: AssetImage('images/base/back.png'),
                         ),
                     ),
                   ),
                   Text('SETTINGS',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontFamily: 'tengxun',
                       color: Colors.white,
                       fontSize: 22,
                     ),
                   ),
                   Text('123456')
                 ],
               ),
             ),
             // Container(
             //   margin: EdgeInsets.only(top: 40),
             //   child: ProfileDataListView() ,
             // ),

             Expanded(child: Padding(
               padding: EdgeInsets.only(left: 24, right: 24),
               child: SettingListView(datas: data,),
             )
             )
           ]
         ),
      ),
    );
  }

}
