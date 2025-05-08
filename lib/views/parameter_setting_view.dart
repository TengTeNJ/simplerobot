import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/views/slider_view.dart';

import '../models/robot_data_model.dart';
import '../utils/ble_send_util.dart';
import '../utils/data_base.dart';

/// 参数设置view
class ParameterSettingView extends StatefulWidget {
  //const ParameterSettingView({super.key});

  double outRollerSpeedValue;

  ParameterSettingView({required this.outRollerSpeedValue});


  @override
  State<ParameterSettingView> createState() => _ParameterSettingViewState();
}

class _ParameterSettingViewState extends State<ParameterSettingView> {
 String rollerSpeed = '0.42m/s';
 String ballType = '70kpa';
 double rollerSpeedDefaultValue = 1.0;
 double ballTypeDefaultValue = 2.0;

 late Future<int> speedCount;
 late Future<int> ballTypeCount;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // speedCount = fetchSpeedCount();
   Future.delayed(Duration(milliseconds: 10),(){
      getDBSpeedData();

      speedCount.then((int value){
        rollerSpeedDefaultValue = value.toDouble();
      });

      ballTypeCount.then((int value){
        ballTypeDefaultValue = value.toDouble();
      });

   });
  }

 Future<void> getDBSpeedData () async {
   speedCount = DataBaseHelper().fetchRobotSpeedData();
   var currentRobotSpeed = await DataBaseHelper().fetchRobotSpeedData();
   if (currentRobotSpeed == 0) {
     currentRobotSpeed = 1;
   }
   print('111${currentRobotSpeed}');
    if (currentRobotSpeed == 1) {
      rollerSpeedDefaultValue = 1.0;
      rollerSpeed = '0.4m/s';
    } else if (currentRobotSpeed == 2) {
      rollerSpeedDefaultValue = 2.0;
      rollerSpeed = '0.42m/s';

    } else {
      rollerSpeedDefaultValue = 3.0;
      rollerSpeed = '0.45m/s';
    }

    ballTypeCount = DataBaseHelper().fetchBallTypeData();
   var currentBallType = await DataBaseHelper().fetchBallTypeData();
   print('222${currentBallType}');

   setState(() {
     if (currentBallType == 1) {
       ballTypeDefaultValue = 1.0;
       ballType = '65kpa';
     } else if (currentBallType == 2) {
       ballTypeDefaultValue = 2.0;
       ballType = '70kpa';
     } else {
       ballTypeDefaultValue = 3.0;
       ballType = '75kpa';
     }
   });
 }


 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: Constants.screenWidth(context) - 88,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.boldWhiteTextWidget("Roller Speed", 18),
                Constants.regularWhiteTextWidget('${rollerSpeed}', 16, Constants.selectedModelOrangeBgColor),
              ],
            ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16,left: 44,right: 44),
          width: Constants.screenWidth(context) - 88,
          height: 42,
          decoration: BoxDecoration( color: Color.fromRGBO(39, 41, 51, 1),
          borderRadius: BorderRadius.circular(21.0),
       ),
        child: FutureBuilder<int>(
            future: speedCount,
            builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                   return SliderView(defaultValue: rollerSpeedDefaultValue,chooseValue: (value){
                           if (value == 1.0) {
                            BleSendUtil.setSpeed(RobotSpeed.slow); //低速
                            DataBaseHelper().saveRobotSpeedData(1);
                            rollerSpeed = '0.4m/s';
                        } else if(value == 2.0) {
                           BleSendUtil.setSpeed(RobotSpeed.fast); //高速
                           DataBaseHelper().saveRobotSpeedData(2);
                           rollerSpeed = '0.42m/s';

                     } else {
                           BleSendUtil.setSpeed(RobotSpeed.faster); //超高速
                           DataBaseHelper().saveRobotSpeedData(3);
                           rollerSpeed = '0.45m/s';
                          }
                         setState(() {});
                           },);
            }),
        ),
        Container(
          width: Constants.screenWidth(context) - 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.regularWhiteTextWidget('1', 18, Constants.connectTextColor),
              Constants.regularWhiteTextWidget('2', 18, Constants.connectTextColor),
              Constants.regularWhiteTextWidget('3', 18, Constants.connectTextColor),
            ],
          ),
        ),
        SizedBox(height: 52,),
        /// balll type
        Container(
          width: Constants.screenWidth(context) - 88,
          //color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.boldWhiteTextWidget("BallType", 18),
              Constants.regularWhiteTextWidget('${ballType}', 16, Constants.selectedModelOrangeBgColor),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16,left: 44,right: 44),
          // color: Color.fromRGBO(39, 41, 51, 1),
          width: Constants.screenWidth(context) - 88,
          height: 42,
          decoration: BoxDecoration( color: Color.fromRGBO(39, 41, 51, 1),
            borderRadius: BorderRadius.circular(21.0),
          ),
          child: FutureBuilder<int>(
              future: ballTypeCount,
              builder: (BuildContext context,AsyncSnapshot<int> value){
              return  SliderView(defaultValue: ballTypeDefaultValue,chooseValue:(value){
                  if (value == 1.0) {
                    BleSendUtil.setRobotCollectingWheelSpeed(1);
                    DataBaseHelper().saveBallTypeData(1);
                    ballType = '65kpa';
                  } else if(value == 2.0) {
                    BleSendUtil.setRobotCollectingWheelSpeed(2);
                    DataBaseHelper().saveBallTypeData(2);
                    ballType = '70kpa';

                  } else {
                    BleSendUtil.setRobotCollectingWheelSpeed(3);
                    DataBaseHelper().saveBallTypeData(3);
                    ballType = '75kpa';
                  }
                  setState(() {});
                } ,);

              }),
        ),
        Container(
          width: Constants.screenWidth(context) - 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.regularWhiteTextWidget('1', 18, Constants.connectTextColor),
              Constants.regularWhiteTextWidget('2', 18, Constants.connectTextColor),
              Constants.regularWhiteTextWidget('3', 18, Constants.connectTextColor),
            ],
          ),
        ),
      ],

    );
  }
}
