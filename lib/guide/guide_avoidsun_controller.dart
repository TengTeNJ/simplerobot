import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/NativeCommunication.dart';
import '../utils/navigator_util.dart';

/// 避免阳关直射提示
class GuideAvoidsunController extends StatefulWidget {
  const GuideAvoidsunController({super.key});

  @override
  State<GuideAvoidsunController> createState() => _GuideAvoidsunControllerState();
}

class _GuideAvoidsunControllerState extends State<GuideAvoidsunController> {
  static const platfrom = MethodChannel('native_screen');
  
  void openNativeScreen() async {
    try {
      await platfrom.invokeMethod('openNativeScreen');
    } on PlatformException catch(e) {
      print('Failed to open native screen: ${e.message}');
    }
  }

  void sendDataToSwift() async {
    try {
      await platfrom.invokeMethod('fLutterSendMessage', {'message': '当前电量8%'});
    } on PlatformException catch(e) {
      print('Failed to open native screen: ${e.message}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromSwift();
   // sendDataToSwift();
  }

  // void sendDataToSwift() async {
  //   await NativeCommunication().sendDataToNative("电量10%");
  // }
  void getDataFromSwift() async {
     await NativeCommunication().getDataFromNative();
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
               // NavigatorUtil.push(Routes.cameraCalibration);

                openNativeScreen();
                sendDataToSwift();

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
