
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_robot/models/language_model.dart';
import 'package:vibration/vibration.dart';

import '../constant/constants.dart';
import '../utils/ble_send_util.dart';
import '../utils/data_base.dart';
import '../utils/navigator_util.dart';
import 'asserts_image_builder.dart';
import 'image_slider_thumb.dart';


/// 新的界面 设置ball Type
class NewSettingBallTypeController extends StatefulWidget {
  const NewSettingBallTypeController({super.key});

  @override
  State<NewSettingBallTypeController> createState() => _NewSettingBallTypeControllerState();
}

class _NewSettingBallTypeControllerState extends State<NewSettingBallTypeController> {
  String chooseValue = "70";
  double sliderDefault = 70;

  late ImageProvider imageProvider = AssetImage('images/base/slider_shape.png');



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDBBallTYpeData();
  }

  Future<void> getDBBallTYpeData () async {
    var  currentBallType = await DataBaseHelper().fetchBallTypeData();
    if (currentBallType == 1) {
      chooseValue = '65';
      sliderDefault = 65;
    } else if (currentBallType == 2) {
      chooseValue = '70';
      sliderDefault = 70;

    } else {
      chooseValue = '75';
      sliderDefault = 75;
    }

    setState(() {});
  }

  Widget buildSliderWidget() {
    return Slider(
      //Slider的当前的值  0.0 ~ 1.0
      value: sliderDefault,
      min: 65,
      max: 75,
      //平均分成的等分
      divisions: 2,
      //滚动时会回调
      onChanged: (double value) {
        Vibration.vibrate(duration: 500); // 触发震动
        chooseValue = value.toInt().toString();
        sliderDefault = value;
        if (value == 65) {
          BleSendUtil.setRobotCollectingWheelSpeed(1);
          DataBaseHelper().saveBallTypeData(1);
        } else if (value == 70) {
          BleSendUtil.setRobotCollectingWheelSpeed(2);
          DataBaseHelper().saveBallTypeData(2);
        } else {
          BleSendUtil.setRobotCollectingWheelSpeed(3);
          DataBaseHelper().saveBallTypeData(3);
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
      label: "${sliderDefault}",
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

                    Constants.boldWhiteTextWidget('Ball Type', 22),
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
                height: 31 * 3,
                width: 84 * 3,
                child: Image(
                  image: AssetImage('images/profile/setting_balltype.png'),
                  fit: BoxFit.fill,
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 37),
                width: Constants.screenWidth(context)- 100,
                child: Constants.mediumWhiteTextWidget('${Provider.of<LanguageModel>(context,listen: false).getText("调节机器人收球速度")}', 17, Colors.white,maxLines: 3),
              ),




              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 40),
                child: Center(
                    child:
                    Constants.mediumWhiteTextWidget("${chooseValue}kpa", 18, Constants.selectedModelBgColor)
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 4 ),
                width: Constants.screenWidth(context) -120 ,
                height: 50,
                child: buildThem(),
                // child: SliderView(defaultValue: sliderDefault,chooseValue: (value){
                //     setState(() {
                //       chooseValue = value.toInt().toString();
                //       if (chooseValue == '65') {
                //         BleSendUtil.setRobotCollectingWheelSpeed(1);
                //         DataBaseHelper().saveBallTypeData(1);
                //         print('1档位');
                //       } else if(chooseValue == '70') {
                //         BleSendUtil.setRobotCollectingWheelSpeed(2);
                //         DataBaseHelper().saveBallTypeData(2);
                //         print('2档位');
                //
                //       } else {
                //         BleSendUtil.setRobotCollectingWheelSpeed(3);
                //         DataBaseHelper().saveBallTypeData(3);
                //         print('3档位');
                //
                //       }
                //     });
                // },),
              ),

              Container(
                // color: Colors.red,
                width: Constants.screenWidth(context) - 140,
                // margin: EdgeInsets.only(left: 70 ,right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.mediumWhiteTextWidget('1', 18, Constants.connectTextColor),
                    Constants.mediumWhiteTextWidget('2', 18, Constants.connectTextColor ),
                    Constants.mediumWhiteTextWidget('3', 18, Constants.connectTextColor ),
                  ],
                ),
              ),

              SizedBox(height: 28,),
            ],
          ),
        ),
      ),
    );

  }
}
