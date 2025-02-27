import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/route/routes.dart';

import '../utils/navigator_util.dart';

/// 相机校准界面
class CameraCalibrationController extends StatefulWidget {
  const CameraCalibrationController({super.key});

  @override
  State<CameraCalibrationController> createState() =>
      _CameraCalibrationControllerState();
}

class _CameraCalibrationControllerState
    extends State<CameraCalibrationController> {
  late CameraController _controller;
  late CameraPreview _preview;
  late Future<void> _initializeControllerFuture;

  var  cameraRatio = 0.0;


  @override
  void initState() {
    super.initState();
    // 锁定设备方向为横屏
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized(); // 确保 Flutter 绑定初始化
    final cameras = await availableCameras(); // 获取设备上的摄像头列表
    final firstCamera = cameras.first; // 使用第一个摄像头
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium, // 设置分辨率
      enableAudio: false, // 禁用音频（如果不需要）
    );
    await _controller.initialize(); // 初始化摄像头
    _preview = CameraPreview(_controller);

    cameraRatio = _controller.value.aspectRatio;
    setState(() {}); // 触发界面更新
  }


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
                    child:  CameraPreview(
                          _controller,
                        ),
                  ),
                ),

              ),
            ),

            Positioned(
                left: 32,
                top: 32,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.pop();
                  },
                  child: Container(
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

                )
            ),

            Positioned(
                right: 32,
                top: 32,
                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.cameraPick);
                },
                  child: Container(
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

                )),
            Positioned(
                bottom: 70,
                right: 180,
                left: 180,
                child: Column(
                  children: [
                    Constants.regularWhiteTextWidget('Please position the key points '
                        'of the court within the calibration circle'
                        ' to achieve field of view calibration.', 16 , Colors.white),
                  ],
                )),

          ],
        ),
      ),
    );
  }
}
