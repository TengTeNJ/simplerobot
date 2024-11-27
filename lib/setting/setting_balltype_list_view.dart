import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/setting_button.dart';
import 'package:tennis_robot/utils/cancel_button.dart';

class SettingBalltypeListView extends StatefulWidget {
  const SettingBalltypeListView({super.key});

  @override
  State<SettingBalltypeListView> createState() => _SettingBalltypeListViewState();
}

class _SettingBalltypeListViewState extends State<SettingBalltypeListView> {
  @override
  Widget build(BuildContext context) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
        // GestureDetector(onTap: ,)

         Padding(padding: EdgeInsets.only(top: 46,left: 16),
           child:Image(image: AssetImage('images/profile/balltype_gray_icon.png'),width: 62,height: 62,),
         ),

         Padding(padding: EdgeInsets.only(top: 46,right: 24),
           child: SettingButton(title: 'Soft Ball',isSelected: true,close: (){

           },),
         )

       ],

     );
  }
}
