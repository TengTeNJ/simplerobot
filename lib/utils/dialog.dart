// import 'package:code/views/dialog/dialog.dart';
import 'package:tennis_robot/utils/cancel_button.dart';
import 'package:tennis_robot/utils/color.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/base_button.dart';
import 'package:flutter/material.dart';

class TTDialog {
  /* 机器人结束任务弹窗*/
  static robotEndTaskDialog(BuildContext context, Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: RobotEndTaskDialog(exchange: exchange),
            ),
          );
        }
    );
  }

  static robotEXceptionDialog(BuildContext context,String title,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotExceptionDialog(exchange: exchange,title: title),
            ),
          );
        }
    );

  }

  static robotModeAlertDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotModelAlertDialog(exchange: exchange),
            ),
          );
        }
    );

  }
  // 低电量提醒
  static robotLowBatteryDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Low Battery',descTitle: '20% battery remaining Please recharge your Bot',imgName: 'images/base/low_battery.png',),
            ),
          );
        }
    );
  }
  // 蓝牙断链提醒
  static robotBleDisconnectDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Bluetooth Disconnected',descTitle: 'Bluetooth disconnected Please check your Bot',imgName: 'images/base/ble_disconnect.png',),
            ),
          );
        }
    );
  }

  // 卡停提醒
  static robotRobotStopDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Stuck',descTitle: 'The Bot is Stuck Please check your Bot',imgName: 'images/base/stop_alarm.png',),
            ),
          );
        }
    );
  }

  // 结束任务提醒
  static robotEndTask(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Exit',descTitle: 'Seekerbot will stop working',imgName: 'images/base/robot_back.png',),
            ),
          );
        }
    );
  }
}

/*机器人模式提示弹窗*/
class RobotModelAlertDialog extends StatelessWidget {
  Function exchange;

  RobotModelAlertDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),

          SizedBox(
            height: 27,
          ),

          Constants.boldWhiteTextWidget('Training Mode', 20),

          SizedBox(
            height: 45,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/base/train_mode_a.png'),
                width: 153 /2,
                height: 183 /2,
              ),

              SizedBox(
                width: 12,
              ),

              Image(image: AssetImage('images/base/train_mode_b.png'),
                width: 153 /2,
                height: 183 /2,
              ),
            ],

          ),

          SizedBox(
            height: 32,
          ),

          Padding(padding: EdgeInsets.only(left: 34,right: 34),
            child: Text('When Serve&Volley training and the robot will no longer enter the court to pick up the ball',
              textAlign: TextAlign.center,
              // overflow: TextOverflow.visible,
              style: TextStyle(
                color: Constants.connectTextColor,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'SanFranciscoDisplay',
                fontWeight: FontWeight.w400,
              ),
            ) ,
          ),



          SizedBox(
            height: 45,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Confirm',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

class RobotLowBatteryDialog extends StatelessWidget {
  Function exchange;
  String descTitle;
  String title;
  String imgName;


  RobotLowBatteryDialog({required this.exchange,required this.title,required this.descTitle,required this.imgName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),

          SizedBox(
            height: 33,
          ),

          Image(image: AssetImage('${this.imgName}'),
            width: 96 /2,
            height: 83 /2,
          ),

          SizedBox(
            height: 11,
          ),
          Constants.boldWhiteTextWidget('${this.title}', 19),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('${this.descTitle}', 16,Constants.connectTextColor),

          SizedBox(
            height: 84,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(20),
              title: 'Got It',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

/*机器人异常弹窗*/
class RobotExceptionDialog extends StatelessWidget {
  Function exchange;
  String title;

  RobotExceptionDialog({required this.exchange,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),

          SizedBox(
            height: 33,
          ),

          Image(image: AssetImage('images/base/exception_icon.png'),
            width: 96 /2,
            height: 83 /2,
          ),

          SizedBox(
            height: 11,
          ),
          Constants.boldWhiteTextWidget('Exception', 20),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('${this.title}', 14,Constants.connectTextColor),

          SizedBox(
            height: 84,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Confirm',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}


//*机器人结束提示弹窗*/
class RobotEndTaskDialog extends StatelessWidget {
  Function exchange;

  RobotEndTaskDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),
          SizedBox(
            height: 90,
          ),
          Constants.boldWhiteTextWidget('End a Task?', 20),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('Whether to end the current mode', 14,Constants.connectTextColor),

          SizedBox(
            height: 84,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Finish',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
