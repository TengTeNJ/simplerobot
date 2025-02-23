import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/navigator_util.dart';

/// 引导页面
class GuidePageController extends StatefulWidget {
  const GuidePageController({super.key});

  @override
  State<GuidePageController> createState() => _GuidePageControllerState();
}

class _GuidePageControllerState extends State<GuidePageController> {
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]); // 设置竖屏模式
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]); // 设置横屏模式
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(onTap: (){
               NavigatorUtil.pop();
             },
               child: Container(
                 margin: EdgeInsets.only(top: 32,left: 32),
                 width: 52,
                 height: 52,
                 color: Constants.selectedModelOrangeBgColor,
               ),
             ),


             GestureDetector(onTap: (){
               NavigatorUtil.push(Routes.guideCameraPlacementPage);
             },
               child: Container(
                 margin: EdgeInsets.only(top: 32,right: 32),
                 width: 52,
                 height: 52,
                 color: Constants.selectedModelOrangeBgColor,
               ),
             ),
           ],
         ),

         Constants.mediumWhiteTextWidget('Intelligent Mode', 36, Colors.white),
         SizedBox(height: 25,),
         Center(
           child: Image(
               width: 233,
               height: 130,
               image: AssetImage('images/home/under_way.png')),
         ) ,
          SizedBox(height: 25,),
          Constants.regularWhiteTextWidget('In the intelligent mode, '
             'your robot will remain within the boundaries of the court,'
             ' and you can select the position to which the robot returns '
             'after the balls are full by clicking the HOME icon.', 16, Colors.white),
        ],

      ),
    );

  }
}
