import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tennis_robot/models/robot_data_model.dart';
import 'package:tennis_robot/pickmode/robot_speed_adjust_view.dart';
import 'package:tennis_robot/trainmode/mode_switch_view.dart';
import 'package:tennis_robot/utils/ble_send_util.dart';
import 'package:tennis_robot/utils/event_bus.dart';
import 'package:tennis_robot/views/remote_control_view.dart';
import 'package:vibration/vibration.dart';

import '../constant/constants.dart';
import '../customAppBar.dart';
import '../models/pickup_ball_model.dart';
import '../route/routes.dart';
import '../startPage/action_data_list_view.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/data_base.dart';
import '../utils/dialog.dart';
import '../utils/navigator_util.dart';
import '../utils/robot_manager.dart';
import '../utils/robot_send_data.dart';
import '../utils/string_util.dart';

enum SelectedMode {
  pickMode,// 捡球模式
  controlMode // 遥控模式
}

// 捡球模式
class PickModeController extends StatefulWidget {
  const PickModeController({super.key});

  @override
  State<PickModeController> createState() => _PickModeControllerState();
}

class _PickModeControllerState extends State<PickModeController> {
  SelectedMode selectedMode = SelectedMode.pickMode;
  int todayPickUpBalls =0; // 今日捡球的数量
  int todayRobotWorkTime = 0; // 机器人今日工作的时间
  int todayCal = 0; // 今日消耗的卡路里
  var imageName = 'mode_start';

  bool lowBatteryAlertIsShow = false; // 低电量弹窗是否弹出过
  bool shutDownAlertIsShow = false; // 低电量关机弹窗是否弹出过


  // 获取今日的捡球数
  void getTodayBallNumsByDB() async{
    final _list  = await DataBaseHelper().getData(kDataBaseTableName);
    var todayTime = StringUtil.currentTimeString();
    // 先取出今日的捡球数量
    _list.forEach((element){
      if (element.time == todayTime) {
        setState(() {
          todayPickUpBalls = int.parse(element.pickupBallNumber);
          calculateTodayKal(todayPickUpBalls);
        });
      }
    });
  }

  // 今日的卡路里计算
  void calculateTodayKal(int todayBallNumber) {
    // 平均50个球3分钟 --> 平均打一个球需要3.6秒
    // 卡路里计算公式
    // CBT = TT/60 * 650 * BW/150; CBT是消耗的卡路里数，TT是打网球的总时间（分钟），BW是体重
    var minute = (todayBallNumber * 3.6)/60 .toInt();
    todayCal = (minute / 60 * 650 * 120 / 150).toInt();
    print('今天消耗的卡路里${todayCal}');
  }

  // 获取今日机器人工作时间
  void getTodayRobotUserTime() async {
    final _list = await DataBaseHelper().getRobotWorkTimeData(kDataBasePickupBallTimeTableName);
    var todayTime = StringUtil.currentTimeString();
    _list.forEach((element){
      if (element.time == todayTime) {
        setState(() {
          todayRobotWorkTime = (int.parse(element.pickupBallTime)) ~/ 60;
        });
      }
    });
  }

  void initState() {

    // 断链退到连接界面
  BluetoothManager().disConnect = () {
    TTDialog.robotBleDisconnectDialog(context, () async {
         NavigatorUtil.popToRoot();
    });
  };

    // 先发一个心跳包，Fly那边是根据心跳包判断连接状态（不然设置机器人模式会设置不成功）
    var list = BluetoothManager().deviceList;
    if (list.length >0) {
      setState(() {
        for (var model in list) {
          if (model.device.name == kBLEDevice_NewName) {
             BluetoothManager().writerDataToDevice(model, heartBeatData());
          }
        }
      });
    }

    // 界面一进来默认是捡球训练模式
    Future.delayed(Duration(milliseconds: 500), () {
      BleSendUtil.setRobotMode(RobotMode.training);
    });
    // 默认设置机器人的速度
    getDBSpeedData();

    getTodayBallNumsByDB();
    getTodayRobotUserTime();
    //机器人工作时间回调
    BluetoothManager().workTimeChange = (time) {
      print('机器人工作时间回调${time}');
      EventBus().sendEvent(kRobotPickballTimeChange);
      setState(() {
        todayRobotWorkTime = (int.parse(time)) ~/ 60;
      });
    };

    // 监听捡球数变化
    RobotManager().dataChange = (TCPDataType type) {
      int power = RobotManager().dataModel.powerValue;
      if (power < 20 && power > 5) {
        if (lowBatteryAlertIsShow == false) {
          lowBatteryAlertIsShow = true;
          // 低电量弹窗
          TTDialog.robotLowBatteryDialog(context,currentBattery: power,() async {
            NavigatorUtil.pop();
          });
        }
      }

      if (power <=5  && shutDownAlertIsShow == false) { // 提示关机弹窗
         shutDownAlertIsShow = true;
         TTDialog.robotLowBatteryDialog(context,currentBattery: power, () async {
           NavigatorUtil.pop();
         });
      }

      if(type == TCPDataType.finishOneFlag) { // 機器人撿球成功上報
        print('robot finishOneFlag');
        setState(() {
          todayPickUpBalls += 1;
          // 卡路里刷新
          calculateTodayKal(todayPickUpBalls);
        });
        getBallData();// 数据库处理
        EventBus().sendEvent(kRobotPickballCountChange);

      } else if(type == TCPDataType.errorInfo) { // 异常信息
        var desc = '';
        var status = RobotManager().dataModel.errorStatu;
        if (status == 1) {  // 1 收球轮异常故障
          desc = 'Abnormal malfunction of the ball receiving wheel';
        } else if(status == 2) { //行走轮异常故障
          desc = 'Abnormal malfunction of the walking wheel';
        } else if(status == 3) { //摄像头异常故障
          desc = 'Camera malfunction';
        } else if (status == 4) { // 雷达异常故障
          desc = 'Radar abnormal malfunction';
        }

      } else if(type == TCPDataType.warnInfo) { // 告警信息
        print('robot warnInfo');
      }
    };
  }

  void getBallData() async {
    final _list  = await DataBaseHelper().getData(kDataBaseTableName);
    List<String> timeArray = [];
    _list.forEach((element){
      timeArray.add(element.time);
    });
    var todayTime = StringUtil.currentTimeString();
    var model = PickupBallModel(pickupBallNumber: todayPickUpBalls.toString(), time: todayTime);

    if (timeArray.contains(todayTime)) {
      print('数据库有当天的捡球数');
      DataBaseHelper().updateData(kDataBaseTableName, model.toJson(), model.time);
    } else {
      DataBaseHelper().insertData(kDataBaseTableName, model);
    }
  }

  /// 默认设置机器人的速度  默认设置BallType
  Future<void> getDBSpeedData () async {
    var currentRobotSpeed = await DataBaseHelper().fetchRobotSpeedData();
    if (currentRobotSpeed == 0) {
      currentRobotSpeed = 1;
    }
    if (currentRobotSpeed == 2) {
      BleSendUtil.setSpeed(RobotSpeed.fast); //高速
      print('默认机器人速度为高速');
    } else if (currentRobotSpeed == 3) {
      BleSendUtil.setSpeed(RobotSpeed.faster); //超高速
      print('默认机器人速度为超高速');
    } else {
      BleSendUtil.setSpeed(RobotSpeed.slow); //低速
      print('默认机器人速度为低速');
    }

    /// 默认设置BallType
    var currentBallType = await DataBaseHelper().fetchBallTypeData();
    if (currentBallType == 0) {
      print('收球轮速度慢速${currentBallType}');
      Future.delayed(Duration(milliseconds: 100),() {
        BleSendUtil.setRobotCollectingWheelSpeed(1);
      });
    } else {
      print('收球轮速度快速${currentBallType}');
      Future.delayed(Duration(milliseconds: 100),() {
        BleSendUtil.setRobotCollectingWheelSpeed(2);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Container(
          children: [
            Container(
              margin: EdgeInsets.only(left: 24) ,
              child: GestureDetector( onTap: (){
                TTDialog.robotEndTask(context, () async{
                  NavigatorUtil.pop();
                  NavigatorUtil.pop();
                  BleSendUtil.setRobotMode(RobotMode.rest);
                });
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      width:24,
                      height: 24,
                      image: AssetImage('images/base/back.png'),
                    ),
                    Text('Seekerbot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'tengxun',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Text('123456')
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 64),
              width: Constants.screenWidth(context),
              child: ActionDataListView(todayCount: '${todayPickUpBalls}',useMinutes: todayRobotWorkTime,todayCal: todayCal,),
            ),
            selectedMode == SelectedMode.pickMode ?
            Container(
              // margin: EdgeInsets.only(left: Constants.screenWidth(context)/2 - 102,top: 102),
              margin: EdgeInsets.only(left:0,top: 64),
              child: GestureDetector(onTap: (){
                if (imageName == 'mode_start') {
                  BleSendUtil.setRobotMode(RobotMode.rest);
                  print('shutdown rest');
                } else {
                  BleSendUtil.setRobotMode(RobotMode.training);
                  print('start training');
                }
                Vibration.vibrate(duration: 500);
                setState(() {
                  imageName = imageName == 'mode_start' ? 'mode_pause' :'mode_start';
                });
              },
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 0,top: 10)),
                    Image(image: AssetImage('images/home/${imageName}.apng'),
                      width:204,
                      height: 204,
                    ),
                  ],
                ),

              ),
            ) : Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 68),
              child: RemoteControlView(),
            ),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: selectedMode == SelectedMode.pickMode ? 110 : 75),
              child: ModeSwitchView(areaClick: (index){
                setState(() {
                  Vibration.vibrate(duration: 500); // 触发震动
                  if(index == 0) {
                    selectedMode = SelectedMode.pickMode;
                    if (imageName == 'mode_start'){
                      BleSendUtil.setRobotMode(RobotMode.training);
                      print('捡球模式');
                    } else {
                      BleSendUtil.setRobotMode(RobotMode.rest);
                      print('暂停模式');
                    }
                    print('123456${Constants.screenHeight(context)}');
                    print('宽${Constants.screenWidth(context)}');
                  } else {
                    print('遥控模式');
                    selectedMode = SelectedMode.controlMode;
                    BleSendUtil.setRobotMode(RobotMode.remote);

                    // 500毫秒-> 设置控制角度为零，防止Fly那边报错
                    Future.delayed(Duration(milliseconds: 500), () {
                      print('设置角度为0');
                      BleSendUtil.setRobotAngle(0);
                    });

                    // 卡停弹窗
                    // TTDialog.robotRobotStopDialog(context, () async{
                    //   NavigatorUtil.pop();
                    // });

                  }
                });
              },),
            ),
          ],
        ),
      ),
    );
  }
}
