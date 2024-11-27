import 'package:flutter/material.dart';
import 'package:tennis_robot/profile/profile_data_list_view.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/setting/setting_roller_speed.dart';

import '../utils/navigator_util.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
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
                     child:Image(
                       width:24,
                       height: 24,
                       image: AssetImage('images/base/back.png'),
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
             Container(
               margin: EdgeInsets.only(top: 40),
               child: ProfileDataListView() ,
             ),
           ]
         ),
      ),
    );
  }

}
