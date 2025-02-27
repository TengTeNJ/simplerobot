import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tennis_robot/guide/view/choose_mode_bgview.dart';
import 'package:tennis_robot/guide/view/mode_switch_view.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/navigator_util.dart';

/// 鹰眼系统捡球界面
class CameraPickController extends StatefulWidget {
  const CameraPickController({super.key});

  @override
  State<CameraPickController> createState() => _CameraPickControllerState();
}

class _CameraPickControllerState extends State<CameraPickController> {
  late CameraController _controller;
  late CameraPreview _preview;
  late Future<void> _initializeControllerFuture;

  var  cameraRatio = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Opacity(opacity: 0.4,
              child: SizedBox(
                width: Constants.screenWidth(context),
                height: Constants.screenHeight(context),
                child: Transform.rotate(angle: -3.14 /2,
                  child: AspectRatio(
                    aspectRatio: cameraRatio,
                    child:  Container(),
                    // CameraPreview(
                    //   _controller,
                    // ),
                  ),
                ),
              ),
            ),

            Positioned(
                left: 24,
                top: 24,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.pop();
                }, child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:Color.fromRGBO(19, 19, 20, 1.0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:Center(
                    child: Image(image: AssetImage('images/camerapick/back_icon.png'),width: 7,height: 14,),
                  ),
                ),
                )),

            /// 休息模式 训练模式切换 view
            Positioned(
                right: 24,
                top: 24,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  width: 140,
                  height: 36,
                  child: ModeSwitchView(),
                ),
                )),


            Positioned(
                left: 82,
                top: 60,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  width: 500,
                  height: 280,
                  child: Image(image: AssetImage('images/camerapick/outer_court.png')),
                ),
                )),

            Positioned(
                left: 165,
                top: 92,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  width: 334,
                  height: 214,
                  child: Image(image: AssetImage('images/camerapick/inner_court.png')),
                ),
                )),

           Positioned(
               left: 296,
               top: 32,
               child: Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       width: 5,
                       height: 5,
                       color: Color.fromRGBO(194, 35, 38, 1),
                     ),
                     SizedBox(width: 4,),
                     Constants.regularWhiteTextWidget('Camera on', 14, Colors.white),
                     
                   ],
                 ),
               )),

            /// 摄像头位置
            Positioned(
                left: 320,
                top: 64,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  width: 23,
                  height: 25,
                  child: Image(image: AssetImage('images/camerapick/camera_icon.png')),
                ),
                )),

            /// 区域选择View
            Positioned(
                left: 344,
                top: 66,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  width: 54 + 119 + 54 + 4 + 4 +4,
                  height: 266,
                  child: ChooseModeBgview(),
                ),
                )),

            Positioned(
                right:75 ,
                top: 64,
                child:Constants.regularWhiteTextWidget('Mode', 12, Constants.grayTextColor),
            ),

            /// 开始捡球按钮
            Positioned(
                right: 64,
                top: 157,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                }, child: Container(
                  decoration: BoxDecoration(
                    color: Constants.selectedModelOrangeBgColor,
                    borderRadius: BorderRadius.circular(42),
                  ),
                  width: 84,
                  height: 84,
                  child: Center(
                    child: Constants.regularWhiteTextWidget('Start', 20, Colors.white),
                  ),
                ),
                )),

            Positioned(
                right: 83,
                bottom: 35,
                child:  Container(
                  width: 65,
                  height: 36,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width:10,
                          height: 15,
                          image: AssetImage('images/camerapick/camera_battery.png'),
                        ),

                        SizedBox(width: 6),
                        Text('70%',
                          style: TextStyle(
                            fontFamily: 'SanFranciscoDisplay',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Constants.cameraPickBgColor,
                  ),
                ),),

            /// 校准按钮
            Positioned(
                right: 29,
                bottom: 35,
                child: GestureDetector(onTap: (){
                 // NavigatorUtil.push(Routes.cameraPick);
                  NavigatorUtil.popToRoot();
                }, child: Container(
                  decoration: BoxDecoration(
                    color: Constants.cameraPickBgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  width: 36,
                  height: 37,
                  child: Center(
                    child: Center(
                      child: Image(image: AssetImage('images/camerapick/calibration_icon.png'),width:18 ,height: 18,),
                    )
                  ),
                ),
                )),

            Positioned(
                right: 97,
                bottom: 16,
                child: Constants.regularWhiteTextWidget('Bttery', 12, Constants.grayTextColor),
            ),

            Positioned(
              right: 24,
              bottom: 16,
              child: Constants.regularWhiteTextWidget('Calibrate', 12, Constants.grayTextColor),
            ),
          ],
        ),
      ),
    );
  }

}
