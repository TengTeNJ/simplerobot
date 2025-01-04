import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tennis_robot/models/robot_data_model.dart';
import 'package:tennis_robot/setting/asserts_image_builder.dart';
import 'package:tennis_robot/setting/image_slider_thumb.dart';
import 'package:tennis_robot/setting/setting_option_adjust_view.dart';
import 'package:tennis_robot/utils/ble_send_util.dart';
import 'package:tennis_robot/utils/data_base.dart';
import 'package:vibration/vibration.dart';
import '../constant/constants.dart';
import '../utils/navigator_util.dart';

// 机器人速度设置
class SettingRollerSpeed extends StatefulWidget {
  const SettingRollerSpeed({super.key});

  @override
  State<SettingRollerSpeed> createState() => _SettingRollerSpeedState();
}

class _SettingRollerSpeedState extends State<SettingRollerSpeed> {
  double _currentSpeed = 0.4;

  double _sliderValue = 1.0;
  late ImageProvider imageProvider = AssetImage('images/base/slider_shape.png');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDBSpeedData();
  }

  Future<void> getDBSpeedData () async {
    var currentRobotSpeed = await DataBaseHelper().fetchRobotSpeedData();
    if (currentRobotSpeed == 0) {
      currentRobotSpeed = 1;
    }
    _sliderValue = currentRobotSpeed.toDouble();
    if (_sliderValue == 1) {
      _currentSpeed = 0.4;
    } else if (_sliderValue == 2) {
      _currentSpeed = 0.45;
    } else {
      _currentSpeed = 0.5;
    }
    setState(() {});
  }

  Widget buildSliderWidget() {
    return Slider(
      //Slider的当前的值  0.0 ~ 1.0
      value: _sliderValue,
      min: 1,
      max: 3,
      //平均分成的等分
      divisions: 2,
      //滚动时会回调
      onChanged: (double value) {
        Vibration.vibrate(duration: 500); // 触发震动

        _sliderValue = value;
        print("Value $_sliderValue");
        if (value == 2.0) {
          BleSendUtil.setSpeed(RobotSpeed.fast); //高速
          _currentSpeed = 0.45;
        } else if (value == 3.0) {
          BleSendUtil.setSpeed(RobotSpeed.faster); //超高速
          _currentSpeed = 0.5;
        } else {
          BleSendUtil.setSpeed(RobotSpeed.slow); //低速
          _currentSpeed = 0.4;
        }
        setState(() {});
        },
      onChangeStart: (double startValue) {
        print("开始滚动");
      },
      onChangeEnd: (double endValue) {
        print("停止 滚动");
      },
      //气泡
      label: "${_sliderValue.toStringAsFixed(1)}",
    );
  }

  Widget buildThem() {
    return AssertsImageBuilder(imageProvider, builder: (context ,imageInfo){
      return Theme(
        data: ThemeData(
            sliderTheme: SliderThemeData(
             trackHeight: 16,
              //滑块的颜色
              //thumbColor: Colors.deepOrange,
              thumbColor: Constants.selectedModelBgColor,
              //滑块的大小
              //  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18),
              thumbShape: ImageSliderThumb(image: imageInfo?.image),
              //点击滑块边缘的颜色
              // overlayColor: Colors.deepPurpleAccent.withOpacity(0.2),
              // overlayColor: Colors.white,
              //点击滑块边缘的显示半径
             overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
              //滑动左侧滚动条的颜色
              activeTrackColor:  Constants.connectTextColor,
              //滚动条右侧的颜色
              inactiveTrackColor:Constants.connectTextColor,
              //任何情况都显示气泡
              showValueIndicator: ShowValueIndicator.never,
              // 活跃的分段点的颜色
              activeTickMarkColor: Constants.connectTextColor,
              // 不活跃的分段点的颜色
              inactiveTickMarkColor: Constants.connectTextColor,
              //   disabledActiveTickMarkColor: Colors.red,
              //   disabledInactiveTickMarkColor: Colors.red,
              //气泡的文字样式
              //   valueIndicatorTextStyle: TextStyle(color: Colors.white),
              //气泡的背景
              //  valueIndicatorColor: Colors.redAccent
            )
        ),
        child: buildSliderWidget(),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: Constants.darkControllerColor,
      body: ClipRRect(
       borderRadius: BorderRadius.circular(30),
        child: Container(
          width:Constants.screenWidth(context),
          height: Constants.screenHeight(context),
          color: Constants.dialogBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 36,
                margin: EdgeInsets.only(right: 16, top: 16),
                child: Row(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: (){
                      NavigatorUtil.pop();
                      DataBaseHelper().saveRobotSpeedData(_sliderValue.toInt());
                    },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        color:  Constants.dialogBgColor,
                        width: 100,
                        child: Text('Save',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(248, 98, 21, 1),
                            fontSize: 16,
                          ),
                        ),
                      ),),

                    Constants.boldWhiteTextWidget('Roller Speed', 22),
                    Constants.mediumWhiteTextWidget('123456', 16, Constants.dialogBgColor),

                  ],
                ),
              ),
              SizedBox(width: Constants.screenWidth(context),height: 1,),

              Container(
                margin: EdgeInsets.only(top: 20),
                width:  Constants.screenWidth(context),
                height: 1,
                color: Color.fromRGBO(86, 89, 101, 1),
              ),
              
              Container(
                margin: EdgeInsets.only(top: 60),
                height: 92,
                width: 176,
                child: Image(
                  image: AssetImage('images/profile/roller_speed_setting_icon.png'),
                  fit: BoxFit.fill,
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 36),
                child: Center(
                  child:
                  Constants.boldWhiteTextWidget('You can adjust the speed of the robots wheel movement through different gears', 16),
                ),
              ),


              SizedBox(height: 40,),

              Container(
                child: Center(
                  child:
                  Constants.mediumWhiteTextWidget('${_currentSpeed}m/s', 18, Colors.white),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 8),
                width: Constants.screenWidth(context) - 100,
                height: 50,
                child: buildThem(),
              ),

              Container(
                // color: Colors.red,
                width: Constants.screenWidth(context) - 140,
               // margin: EdgeInsets.only(left: 70 ,right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.mediumWhiteTextWidget('1', 18, _sliderValue == 1 ? Constants.customSliderSelectedColor : Constants.customSliderUnselectedColor),
                    Constants.mediumWhiteTextWidget('2', 18, _sliderValue == 2 ? Constants.customSliderSelectedColor : Constants.customSliderUnselectedColor),
                    Constants.mediumWhiteTextWidget('3', 18, _sliderValue == 3 ? Constants.customSliderSelectedColor : Constants.customSliderUnselectedColor),
                  ],
                ),
              ),

              SizedBox(height: 28,),
              _sliderValue == 1.0 ?
              Container(
                child: Center(
                  child:
                  Constants.mediumWhiteTextWidget('Save 20% of the battery.', 16, Color.fromRGBO(248, 98, 21, 1.0)),
                ),
              ) : Container()



            ],
          ),
        ),
      ),
    );
  }
}


