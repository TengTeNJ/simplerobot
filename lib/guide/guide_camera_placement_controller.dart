import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tennis_robot/models/language_model.dart';
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

              Container(
                margin: EdgeInsets.only(top: 36),
                child: Constants.mediumWhiteTextWidget('${Provider.of<LanguageModel>(context).getText("镜头位置")}', 36, Colors.white),
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

          // Constants.mediumWhiteTextWidget('Camera Placement', 36, Colors.white),
          SizedBox(height: 45,),
          Center(
            child: Image(
                width: 233,
                height: 130,
                image: AssetImage('images/guide/guide_second.png')),
          ) ,
          SizedBox(height: 25,),

          Container(
            margin: EdgeInsets.only(left: 78,right: 78),
            child:  Constants.regularWhiteTextWidget('${Provider.of<LanguageModel>(context).getText("镜头位置描述")}', 16, Colors.white,height: 1.5),

          ),


        ],

      ),
    );

  }
}
