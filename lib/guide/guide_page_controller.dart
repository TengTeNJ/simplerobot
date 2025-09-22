import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../models/language_model.dart';
import '../route/routes.dart';
import '../utils/NativeCommunication.dart';
import '../utils/navigator_util.dart';

/// 引导页面
class GuidePageController extends StatefulWidget {
  const GuidePageController({super.key});

  @override
  State<GuidePageController> createState() => _GuidePageControllerState();
}

class _GuidePageControllerState extends State<GuidePageController> {
  static const platfrom = MethodChannel('native_screen');

  void openNativeScreen() async {
    try {
      await platfrom.invokeMethod('openNativeScreen',true);
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
  }

  void getDataFromSwift() async {
    await NativeCommunication().getDataFromNative();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]); // 设置竖屏模式
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]); // 设置横屏模式
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      body: SingleChildScrollView(
        child: Column(
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
                child:  Constants.mediumWhiteTextWidget('${Provider.of<LanguageModel>(context, listen: false).getText('智能捡球模式')}', 36, Colors.white),
              ),

              GestureDetector(onTap: (){
                NavigatorUtil.push(Routes.guideCameraPlacementPage);
                // NavigatorUtil.pushNamedAndRemoveUntil(Routes.guideCameraPlacementPage);
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

          // Container(
          //   margin: EdgeInsets.only(top: 0),
          //   child:  Constants.mediumWhiteTextWidget('Intelligent Mode', 36, Colors.white),
          // ),

          SizedBox(height: 45,),
          Center(
            child: Image(
                width: 233,
                height: 130,
                image: AssetImage('images/guide/guide_first.png')),
          ) ,
          SizedBox(height: 20,),

          Container(
            margin: EdgeInsets.only(left: 88,right: 88),
            child:  Constants.regularWhiteTextWidget('${Provider.of<LanguageModel>(context, listen: false).getText('智能捡球模式描述')}', 16, Colors.white,height: 1.5),
          ),

          Align(
            alignment: Alignment.bottomRight, // 将子控件对齐到右下角
            child: GestureDetector(onTap: (){
               print("跳过");
               openNativeScreen();
               sendDataToSwift();
            },
              child: Container(
                width: 52,
                height: 52,
                margin: EdgeInsets.only(right: 24,bottom: 32),
                decoration: BoxDecoration(
                  color: Constants.dialogBgColor,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Container(
                  // color: Constants.dialogBgColor, // 不能设置颜色，否则颜色不显示
                  child: Center(
                    child: Text(
                      '${Provider.of<LanguageModel>(context,listen: false).getText('跳过')}',
                      style: TextStyle(color: Constants.grayTextColor),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
        ),
      ),
    );

  }
}
