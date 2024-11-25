import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/customAppBar.dart';
import 'package:tennis_robot/models/pickupBall_time.dart';
import 'package:tennis_robot/startPage/action_data_list_view.dart';
import 'package:tennis_robot/utils/event_bus.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';

import '../models/pickup_ball_model.dart';
import '../route/routes.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/data_base.dart';
import '../utils/navigator_util.dart';
import '../utils/robot_manager.dart';
import '../utils/string_util.dart';

Timer? repeatTimer;

// 启动页面
class ActionController extends StatefulWidget {
  const ActionController({super.key});

  @override
  State<ActionController> createState() => _ActionControllerState();
}

class _ActionControllerState extends State<ActionController> {
  int batteryCount = 100; //当前电量数值
  int powerLevels = 5; // 当前电量图标标识

  int todayPickUpBalls =0; // 今日捡球的数量
  int todayRobotWorkTime = 0; // 机器人今日工作的时间
  int todayCal = 0; // 今日消耗的卡路里

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    print('界面初始化');
    getTodayBallNumsByDB();
    getTodayRobotUserTime();


    //机器人工作时间回调
    BluetoothManager().workTimeChange = (time) {
      print('机器人工作时间回调${time}');
      setState(() {
        todayRobotWorkTime = (int.parse(time)) ~/ 60;
      });
    };

    // 监听捡球上报
    RobotManager().dataChange = (TCPDataType type) {
      setState(() {
        int power = RobotManager().dataModel.powerValue;
        batteryCount = power;
        print('电量666 ${power}');
        if (0<power && power<20) {
          powerLevels = 1;
        } else if (20<power && power < 40){
          powerLevels = 2;
        } else if (40<power &&power <60) {
          powerLevels = 3;
        } else if (60<power &&power <80) {
          powerLevels = 4;
        } else {
          powerLevels = 5;
        }
      });
      if (type == TCPDataType.deviceInfo) {
        print('robot battery ${RobotManager().dataModel.powerValue}');

      } else if(type == TCPDataType.speed) {
        print('robot speed ${RobotManager().dataModel.speed}');
      }  else if(type == TCPDataType.finishOneFlag) { // 機器人撿球成功上報
        print('robot finishOneFlag');
        setState(() {
          todayPickUpBalls += 1;
        });
        getBallData();// 数据库处理
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

    // 监听捡球界面的数据回调
    subscription = EventBus().stream.listen((event){
        if (event == kRobotPickballTimeChange) {
            print('机器人捡球时间更新了');
            getTodayRobotUserTime();
        } else if (event == kRobotPickballCountChange) {
          print('机器人捡球数量更新了');
          getTodayBallNumsByDB();
        }
    });
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Container(
          children: [
            Container(
              margin: EdgeInsets.only(top: 6, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Seekerbot',
                    style: TextStyle(
                      fontFamily: 'tengxun',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
              // Padding(padding: EdgeInsets.all(5),

             Container(
               // padding: EdgeInsets.only(top: 10),
               margin: EdgeInsets.only(right: 16),
               width: 34,
               height: 34,
               decoration: BoxDecoration(
                 color: Color.fromRGBO(73, 75, 87, 1),
                 borderRadius: BorderRadius.circular(17),
               ),
                 child: Center(child: Image(image: AssetImage('images/connect/ble_connect.png'),width: 13,),),
             ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 18,top:4),
              child: Row(
                children: [
                  Image(
                    width:32,
                    height: 16,
                    image: AssetImage('images/resetmode/mode_battery_${powerLevels}.png'),
                  ),
                  SizedBox(width: 6),
                  Text('${batteryCount}%',
                    style: TextStyle(
                      fontFamily: 'SanFranciscoDisplay',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 6),
                  Image(
                    width:10,
                    height: 15,
                    image: AssetImage('images/connect/battery_icon.png'),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 24),
              child: Image(
                width: 277,
                height: 215,
                image: AssetImage('images/connect/home_robot.png'),
              ),
            ),
            Container(
                // alignment: Alignment.topCenter,
                // margin: EdgeInsets.only(left: 170 ,top: 10),

                child: GestureDetector(onTap: (){
                  NavigatorUtil.push(Routes.stats);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text('Stats',
                        style: TextStyle(
                          fontFamily: 'SanFranciscoDisplay',
                          color: Constants.selectedModelBgColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 6),
                      Image(
                        color: Colors.red,
                        width:6,
                        height: 10,
                        image: AssetImage('images/connect/more.png'),
                      ),
                    ],
                  ),
                ),
            ),
            Container(
              margin: EdgeInsets.only(top: 18),
              width: Constants.screenWidth(context),
              child: ActionDataListView(todayCount: '${todayPickUpBalls}',useMinutes: todayRobotWorkTime,todayCal: todayCal,),
            ),

            Container(
              margin: EdgeInsets.only(left: 0,top: 10) ,
              child: GestureDetector(onTap: (){
                NavigatorUtil.push(Routes.pickMode);
              },
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    width:118,
                    height: 282,
                    image: AssetImage('images/connect/left_mask.png'),
                  ),
                  Image(
                    width:126,
                    height: 126,
                    image: AssetImage('images/connect/robot_shutdown1.apng'),
                  ),
                  Image(
                    width:118,
                    height: 282,
                    image: AssetImage('images/connect/right_mask.png'),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
