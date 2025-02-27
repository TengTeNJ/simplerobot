import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/navigator_util.dart';

/// 避免阳关直射提示
class GuideAvoidsunController extends StatefulWidget {
  const GuideAvoidsunController({super.key});

  @override
  State<GuideAvoidsunController> createState() => _GuideAvoidsunControllerState();
}

class _GuideAvoidsunControllerState extends State<GuideAvoidsunController> {
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
                  decoration: BoxDecoration(
                    color: Constants.selectedModelOrangeBgColor,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Image(image: AssetImage('images/guide/back_icon.png'),width: 10,height: 20,),
                  ),
                ),

              ),


              GestureDetector(onTap: (){
                NavigatorUtil.push(Routes.cameraCalibration);
              },
                child: Container(
                  margin: EdgeInsets.only(top: 32,right: 32),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Constants.selectedModelOrangeBgColor,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Image(image: AssetImage('images/guide/next_icon.png'),width: 10,height: 20,),
                  ),
                ),
              ),
            ],
          ),

          Constants.mediumWhiteTextWidget('Reminders', 36, Colors.white),
          SizedBox(height: 25,),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    width: 65,
                    height: 65,
                    image: AssetImage('images/guide/guide_three_sun.png')
                ),
                SizedBox(width: 119,),
                Image(
                    width: 65,
                    height: 65,
                    image: AssetImage('images/guide/guide_three_sund.png')
                ),

              ],

            ),
          ),

          SizedBox(height: 25,),
          Constants.regularWhiteTextWidget('Please secure your phone and avoid direct exposure to sunlight.', 16, Colors.white),
        ],

      ),
    );

  }

  // void dispose() {
  //   super.dispose();
  //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]); // 设置竖屏模式
  // }

}
