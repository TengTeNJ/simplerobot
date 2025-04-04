import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tennis_robot/route/routes.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import '../constant/constants.dart';

/// 摄像头放置位置提示
class GuideCameraPlacementController extends StatefulWidget {
  const GuideCameraPlacementController({super.key});

  @override
  State<GuideCameraPlacementController> createState() => _GuideCameraPlacementControllerState();
}

class _GuideCameraPlacementControllerState extends State<GuideCameraPlacementController> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]); // 设置横屏模式
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
                print('点击进行下一步');
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
                NavigatorUtil.push(Routes.guideThreePage);
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
              )
            ],
          ),

          Constants.mediumWhiteTextWidget('Camera Placement', 36, Colors.white),
          SizedBox(height: 25,),
          Center(
            child: Image(
                width: 233,
                height: 130,
                image: AssetImage('images/guide/guide_second.png')),
          ) ,
          SizedBox(height: 25,),

          Container(
            margin: EdgeInsets.only(left: 78,right: 78),
            child:  Constants.regularWhiteTextWidget('Place the phone mount at either end of the tennis court net,'
                ' and position the camera towards the direction of the court you wish to capture, '
                'ensuring that the mount is set higher than the net.', 16, Colors.white,height: 1.5),

          ),


        ],

      ),
    );

  }
}
