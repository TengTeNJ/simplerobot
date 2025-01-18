import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/customAppBar.dart';
import 'package:tennis_robot/models/pickupBall_time.dart';
import 'package:tennis_robot/startPage/action_bottom_view.dart';
import 'package:tennis_robot/startPage/action_data_list_view.dart';
import 'package:tennis_robot/utils/event_bus.dart';
import 'package:tennis_robot/utils/robot_send_data.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../models/pickup_ball_model.dart';
import '../route/routes.dart';
import '../utils/ble_send_util.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/data_base.dart';
import '../utils/dialog.dart';
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

  int _currentIndex = 0; //底部滑动条索引
  bool isAppControlPowerOff = false; // 是否是机器人控制关机的


  void showDisconnectAlert() {
    // 断链退到连接界面
    BluetoothManager().disConnect = () {
      print('首页蓝牙断开');
      EasyLoading.dismiss();
      // app控制关机的不显示蓝牙弹窗
      if (isAppControlPowerOff == true) {
        // 发送通知到连接界面
        EventBus().sendEvent(kRobotConnectChange);
        NavigatorUtil.popToRoot();
      } else {
        TTDialog.robotBleDisconnectDialog(context, () async {
          // 发送通知到连接界面
          EventBus().sendEvent(kRobotConnectChange);
          NavigatorUtil.popToRoot();
        });
      }
    };
  }

  // 捡球关机点击事件回调
  void pickOrPowerOffBack() {
    BluetoothManager().clickIndex = (index){
      if (index == 1) { //关机
        TTDialog.robotPowerOff(context, () async{
          NavigatorUtil.pop();
          BleSendUtil.setRobotPoweroff();
        });
      } else {
        NavigatorUtil.push(Routes.pickMode).then((value){
          listenBattery(); // pop回来监听电量上报
          getTodayBallNumsByDB();// 刷新捡球数，防止两个界面捡球数有差异
          // 断链退到连接界面
          showDisconnectAlert();
        });

      }
    };
  }
  
  @override
  void initState() {
    super.initState();
    showDisconnectAlert();
    pickOrPowerOffBack();
    
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

    print('启动界面');

    listenBattery();
    // 监听捡球界面的数据回调
    subscription = EventBus().stream.listen((event){
        if (event == kRobotPickballTimeChange) {
            print('机器人捡球时间更新了');
            getTodayRobotUserTime();
        } else if (event == kRobotPickballCountChange) {
          print('机器人捡球数量更新了');
          getTodayBallNumsByDB();
        } else if (event == KJumpPickPage) {
          NavigatorUtil.push(Routes.pickMode).then((value){
            print('pop回来刷新电量了${value}');
            listenBattery(); // pop回来监听电量上报
            getTodayBallNumsByDB();// 刷新捡球数，防止两个界面捡球数有差异
            // 断链退到连接界面
            showDisconnectAlert();
          });

        }
    });
  }

  // 监听电量上报
  void listenBattery() {
    // 监听捡球上报 电量上报
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
        setState(() {}
        );
      });
      if (type == TCPDataType.deviceInfo) {
        print('robot battery ${RobotManager().dataModel.powerValue}');
        if (RobotManager().dataModel.powerOn == true){ // app控制机器人关机
          EasyLoading.show(
            status: 'powerOff...',
            maskType: EasyLoadingMaskType.black,
          );
          isAppControlPowerOff = true;
        }
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

  void _pageViewOnChange(int index) {
    _currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      appBar: CustomAppBar(),
      body: WillPopScope(child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Container(
          children: [
            Container(
              margin: EdgeInsets.only(top: 6, left: 16),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Seekerbot',
                        style: TextStyle(
                          fontFamily: 'tengxun',
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(width: 8,),
                      Image(image: AssetImage('images/connect/ble_connect.png',),width: 10,height: 13,),
                    ],
                  ),


                  GestureDetector(onTap: (){

                    NavigatorUtil.push(Routes.setting).then((value){
                      listenBattery(); // pop回来监听电量上报
                      getTodayBallNumsByDB();// 刷新捡球数，防止两个界面捡球数有差异
                      // 断链退到连接界面
                      showDisconnectAlert();
                    });
                    },
                    child:  Container(
                      // padding: EdgeInsets.only(top: 10),
                      margin: EdgeInsets.only(right: 16),
                      width: 26,
                      height: 26,
                      child: Center(child: Image(image: AssetImage('images/profile/profile_setting1.png'),width: 26,),),
                    ) ,
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
                NavigatorUtil.push(Routes.stats).then((value){
                  listenBattery(); // pop回来监听电量上报
                  getTodayBallNumsByDB();// 刷新捡球数，防止两个界面捡球数有差异
                  // 断链退到连接界面
                  showDisconnectAlert();
                });
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
              // color: Colors.orange,
              margin: EdgeInsets.only(top: 18),
              width: Constants.screenWidth(context),
             // height: 100,
              child: ActionDataListView(todayCount: '${todayPickUpBalls}',useMinutes: todayRobotWorkTime,todayCal: todayCal,),
            ),
            Container(
              // height: 20,
              // color: Colors.green,
              margin: EdgeInsets.only(left: 0,top: 0) ,
              child: GestureDetector(onTap: (){
                // NavigatorUtil.push(Routes.pickMode).then((value){
                //   print('pop回来刷新电量了${value}');
                //   listenBattery(); // pop回来监听电量上报
                //   getTodayBallNumsByDB();// 刷新捡球数，防止两个界面捡球数有差异
                //   // 断链退到连接界面
                //   showDisconnectAlert();
                // });
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Image(
                      width:118,
                      height: 282,
                      image: AssetImage('images/connect/left_mask.png'),
                    ),),

                    Container(
                    //  height: 160,
                      width: 160,
                      child: Column(
                        children: [
                          Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 160,
                          height: 160,
                          child: ActionBottomView(onChange: _pageViewOnChange,),
                        ),

                         Container(
                          // color: Colors.orange,
                          margin: EdgeInsets.only(top: 36),
                          height: 10,
                          child:  IndicatorView(
                            count: 2,
                            currentPage: _currentIndex,
                            defaultColor: Color.fromRGBO(49, 52, 67, 1.0),
                            currentPageColor: Color.fromRGBO(248, 98, 21, 1.0),
                          ),
                         ),
                        ],
                      ),
                    ),
                    Expanded(child:  Image(
                      width:118,
                      height: 282,
                      image: AssetImage('images/connect/right_mask.png'),
                    ),),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),onWillPop: (){
        return Future.value(false);
      },),
    );
  }

  // @override
  // void dispose() {
  //   // 在不需要监听事件时取消订阅
  //   subscription.cancel();
  //   super.dispose();
  // }
}
