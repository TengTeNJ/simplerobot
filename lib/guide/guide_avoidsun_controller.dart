import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/NativeCommunication.dart';
import '../utils/dialog.dart';
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
   //  MethodChannel('com.example/native').setMethodCallHandler((call) async {
   //
   //    print('hahahahah${call.method}');
   //    if (call.method == 'openDialog') {
   //
   //      TTDialog.robotEndTask(context, () async{
   //        NavigatorUtil.pop();
   //        NavigatorUtil.pop();
   //      });
   //    }
   //  });


  }

  // void sendDataToSwift() async {
  //   await NativeCommunication().sendDataToNative("电量10%");
  // }
  void getDataFromSwift() async {
     await NativeCommunication().getDataFromNative();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeRight]); // 设置横屏模式
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


              Container(
                margin: EdgeInsets.only(top: 36),
                child:  Constants.mediumWhiteTextWidget('Reminders', 36, Colors.white),
              ),

              GestureDetector(onTap: (){
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

          // Constants.mediumWhiteTextWidget('Reminders', 36, Colors.white),
          SizedBox(height: 25,),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///阳光直射提示
                Container(

                  child: Column(
                    children: [
                      Image(
                          width: 65,
                          height: 65,
                          image: AssetImage('images/guide/guide_three_sun.png')
                      ),
                      SizedBox(height: 12,),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Constants.remindIndicatorColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: 6,),
                            Constants.regularWhiteTextWidget('Avoid direct exposure to sunlight', 16, Colors.white),

                          ],
                        ),
                      ),
                    ],

                  ),
                ),

                ///固定手机提示
                Container(
                  child: Column(
                    children: [
                      Image(
                          width: 65,
                          height: 65,
                          image: AssetImage('images/guide/guide_three_sund.png')
                      ),

                      SizedBox(width: 258,),
                      SizedBox(height: 16,),

                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Constants.remindIndicatorColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: 6,),

                            Constants.regularWhiteTextWidget('Secure your phone', 16, Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
         SizedBox(height: 33,),
          /// 不能遮挡相机提示 与不能让机器人在死角提示
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

            //不能遮挡相机提示
            Container(
            //  color: Colors.red,
              child: Column(
                    children: [
                      Image(
                          width: 65,
                          height: 65,
                          image: AssetImage('images/guide/guide_cover_camera.png')
                      ),

                      SizedBox(height: 12,),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Constants.remindIndicatorColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: 6,),

                            Constants.regularWhiteTextWidget('Avoid covering the camera', 16, Colors.white),

                          ],
                        ),
                      ),
                    ],

                  ),
                ),

                // 不能让机器人在死角提示
                Container(
                  child: Column(
                    children: [
                      Image(
                          width: 88,
                          height: 73,
                          image: AssetImage('images/guide/guide_dead_zone.png')
                      ),

                      SizedBox(width: 288,),
                      SizedBox(height: 12,),

                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Constants.remindIndicatorColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: 6,),
                            Constants.regularWhiteTextWidget('Clear dead zone balls', 16, Colors.white),
                          ],
                        ),
                      ),
                    ],

                  ),
                ),
              ],
            ),
          ),
        ],

      ),
    );

  }

  // void dispose() {
  //   super.dispose();
  //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]); // 设置竖屏模式
  // }

}
