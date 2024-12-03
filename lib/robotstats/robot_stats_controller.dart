import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/customAppBar.dart';
import 'package:tennis_robot/models/pickup_ball_model.dart';
import 'package:tennis_robot/robotstats/my_stats_line_area_view.dart';
import 'package:tennis_robot/robotstats/stats_data_list_view.dart';
import 'package:tennis_robot/utils/navigator_util.dart';

import '../models/my_status_model.dart';
import '../utils/data_base.dart';
import 'package:tennis_robot/startPage/data_bar_view.dart';
import 'game_model.dart';

// 统计数据
class RobotStatsController extends StatefulWidget {
  const RobotStatsController({super.key});

  @override
  State<RobotStatsController> createState() => _RobotStatsControllerState();
}

class _RobotStatsControllerState extends State<RobotStatsController> {
  int totalPickupBallCount = 0;// 总的捡球数量
  int totalRobotWorkTime = 0; //总的机器人工作时间
  String totalPickupBallTimes = '0';// 总的捡球时间

  List<MyStatsModel> datas = [];
  double maxLeft = 0;
  int maxCount = 0; // 最大进球数

  int maxTrainTime = 0; // 最大训练时间
  List<Gamemodel> _datas = []; // 折线图数据
  List<Gamemodel> _aveDatas = [];

  // 组装捡球数量柱状图数据
  Future<void> barChartData() async {
    final _list = await DataBaseHelper().getData(kDataBaseTableName);
    if (_list.length == 0) {
      // 柱状图默认数据
      // MyStatsModel model = MyStatsModel();
      // model.speed = int.parse('100');
      // model.indexString = '0';
      // datas.add(model);
      // maxLeft = max(maxLeft, model.textWidth);
     maxCount = 180;
      setState(() {

      });
      return;
    }
    for (int i = 0 ; i < _list.length ; i++) {
      totalPickupBallCount += int.parse(_list[i].pickupBallNumber);

      MyStatsModel model = MyStatsModel();
      model.speed = int.parse(_list[i].pickupBallNumber);
      model.gameTimer = _list[i].time;
      model.indexString = i.toString();
      datas.add(model);
      maxLeft = max(maxLeft, model.textWidth);
      print('bianju${maxLeft}');
    }
    maxCount = getMaxValue(datas);
    setState(() {

    });
  }

  // 组装训练时间折线图数据
  Future<void> lineChartData() async {
    final _list = await DataBaseHelper().getData(kDataBaseTableName);



    List<Gamemodel> _yourTrainlist = [];
    List<Gamemodel> _avgTrainlist = [];
    List<int> listTime = [];
    if (_list.length == 0) { //折线图默认数据
      maxTrainTime = 120;
      var trainTime = 0;
      listTime.add(trainTime);
      Gamemodel l = Gamemodel(score: '0', indexString: '0');
      _yourTrainlist.add(l);

      Gamemodel avg = Gamemodel(score: '0', indexString: '0');
      _avgTrainlist.add(avg);

       _datas.addAll(_yourTrainlist);
       _aveDatas.addAll(_avgTrainlist);
      return;
    }

    for(int i =0 ;i < _list.length; i ++ ){
      // 平均50个球3分钟 --> 平均打一个球需要3.6秒
       var trainTime = (int.parse(_list[i].pickupBallNumber) * 3.6).toInt();
       print('0000${trainTime}');
       listTime.add(trainTime);
       Gamemodel l = Gamemodel(score: '${trainTime}', indexString: '${i}');
       _yourTrainlist.add(l);

       Gamemodel avg = Gamemodel(score: '90', indexString: '${i}');
       _avgTrainlist.add(avg);
    }
    maxTrainTime = listTime.reduce(max);
    _datas.addAll(_yourTrainlist);
    _aveDatas.addAll(_avgTrainlist);
  }

  // 组装模拟数据数据
  Future<void> chartData() async {
    // var _list = [];
    // // final _list = await DataBaseHelper().getData(kDataBaseTableName);
    // PickupBallModel model = PickupBallModel(pickupBallNumber: '120', time: '2024-10-26');
    // PickupBallModel model1 = PickupBallModel(pickupBallNumber: '150', time: '2024-10-25');
    // PickupBallModel model2 = PickupBallModel(pickupBallNumber: '170', time: '2024-10-24');
    // PickupBallModel model3 = PickupBallModel(pickupBallNumber: '180', time: '2024-10-23');
    // PickupBallModel model4 = PickupBallModel(pickupBallNumber: '140', time: '2024-10-22');
    //
    //
    // _list.add(model);
    // _list.add(model1);
    // _list.add(model2);
    // _list.add(model3);
    // _list.add(model4);
    // _list.add(model4);
    // _list.add(model4);
    // _list.add(model4);
    // _list.add(model4);
    //
    // if (_list.length == 0) {
    //   return;
    // }
    // for (int i = 0 ; i < _list.length ; i++) {
    //   MyStatsModel model = MyStatsModel();
    //   model.speed = int.parse(_list[i].pickupBallNumber);
    //   model.indexString = i.toString();
    //   datas.add(model);
    //   maxLeft = max(maxLeft, model.textWidth);
    // }
    // maxCount = getMaxValue(datas);

    // 折线图的数据
    Gamemodel l = Gamemodel(score: '550', indexString: '1');
    Gamemodel l1 = Gamemodel(score: '200', indexString: '2');
    Gamemodel l2 = Gamemodel(score: '333', indexString: '3');
    Gamemodel l3 = Gamemodel(score: '145', indexString: '4');

    List<Gamemodel> _list1 = [];
    _list1.add(l);
   // _list1.add(l1);
    // _list1.add(l2);
    // _list1.add(l3);

    _datas.addAll(_list1);

    Gamemodel l4 = Gamemodel(score: '300', indexString: '1');
    Gamemodel l5 = Gamemodel(score: '300', indexString: '2');
    Gamemodel l6 = Gamemodel(score: '300', indexString: '3');
    Gamemodel l7 = Gamemodel(score: '300', indexString: '4');

    List<Gamemodel> _list2 = [];
    _list2.add(l4);
    //_list2.add(l5);
    // _list2.add(l6);
    // _list2.add(l7);

    _aveDatas.addAll(_list2);
  }


  int getMaxValue(List<MyStatsModel> items) {
    return items.reduce((max, item) => max.speed > item.speed ? max : item).speed;
  }

  // 机器人总的工作时间
  Future<void> calculateTime() async {
    var totalTime = 0;
    final _list = await DataBaseHelper().getRobotWorkTimeData(kDataBasePickupBallTimeTableName);
    _list.forEach((element){
      totalTime += int.parse(element.pickupBallTime);
    });
    setState(() {
      totalPickupBallTimes = (totalTime ~/ 60).toString();
    });
  }

  @override
  void initState() {
    super.initState();
    barChartData();
    // chartData();
    lineChartData();
    calculateTime();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 24) ,
              child: GestureDetector( onTap: () async{
                NavigatorUtil.pop();
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
                    Text('STATS',
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 46,left: 10),
                    child: StatsDataListView(totalPickUpBallsCount: '${totalPickupBallCount}',totalPickupBallTime: '${totalPickupBallTimes}',),
                  ),

                  Expanded(child: Container(
                    margin: EdgeInsets.only(top: 40,left: 20),
                    child: Image(image: AssetImage('images/connect/home_robot.png'),width: 224,),
                  ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 60),
              child: MyStatsBarChatView(datas: datas,maxLeft: maxLeft + 0.0,maxCount: maxCount,),
            ),

            Container(
              margin: EdgeInsets.only(top: 20,left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' Time on Trainings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'San Francisco Display',
                      color: Constants.selectedModelOrangeBgColor,
                      fontSize: 16,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      //color: Constants.darkThemeColor,

                    ),
                    child: Row(
                      children: [
                        //SizedBox(width: 145,),

                        Container(
                          width: 9,
                          height: 9,
                          color: Constants.selectedModelOrangeBgColor,
                        ),
                        SizedBox(width: 4,),
                        Text('your',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'San Francisco Display',
                            color: Constants.grayTextColor,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(width: 20,),

                        Container(
                          width: 9,
                          height: 9,
                          color: Color.fromRGBO(26, 205, 123, 1.0),
                        ),
                        SizedBox(width: 4,),
                        Text('Avg',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'San Francisco Display',
                            color: Constants.grayTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 0),
              height: 140,
              child: MyStatsLineAreaView(datas: _datas,aveDatas: _aveDatas,maxCount: maxTrainTime,),
            ),
            SizedBox(height: 64,),
          ],
        ),
      ),
    );
  }
}
