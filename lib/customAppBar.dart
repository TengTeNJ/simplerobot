import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  String? title;
  bool? showBack;
  Color? customBackgroundColor;

  CustomAppBar({this.title = '', this.showBack = false, this.customBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading:  showBack == true ? GestureDetector(
        onTap: () {
         // NavigatorUtil.pop();
        },
        child: Container(),

      ):null,
        title: Text(title.toString(),style: TextStyle(color: Colors.white),),
        backgroundColor:  Constants.darkControllerColor,
       centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(44);
}
