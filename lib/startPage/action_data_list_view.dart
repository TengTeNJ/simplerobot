import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tennis_robot/models/pickup_ball_model.dart';
import 'package:tennis_robot/startPage/action_list_view.dart';
import 'package:tennis_robot/utils/color.dart';
import '../models/my_status_model.dart';
import 'package:tennis_robot/utils/data_base.dart';
import 'package:tennis_robot/constant/constants.dart';
import '../utils/string_util.dart';

class ActionDataListView extends StatefulWidget {
  String todayCount;
  int todayCal;
  int useMinutes;

  ActionDataListView({required this.todayCount, required this.useMinutes, required this.todayCal});

  @override
  State<ActionDataListView> createState() => _ActionDataListViewState();
}

class _ActionDataListViewState extends State<ActionDataListView> {
  String todayCount = '0'; //今天捡球数
  int todayCal = 0; // 今日消耗卡路里
  int useMinutes = 0;// 今日使用分钟数

  //计算卡路里消耗 今天捡球数 总的捡球数
  Future<void> calculateCalorie() async {
    var second = await DataBaseHelper().fetchData(); // 今日使用时间
    useMinutes = (second / 60).round();
    // 1个小时能打70个网球
    // 网球卡路里计算公式  CBT = TT/60 * 650 * BW/150; CBT是消耗的卡路里数，TT是打网球的总时间（分钟），BW是体重
    var weight = 120; // 体重
    final _list  = await DataBaseHelper().getData(kDataBaseTableName);
    print('${_list}');
    _list.forEach((element){
      setState(() {
        var todayTime = StringUtil.currentTimeString();
        if (todayTime.contains(element.time)) {
          todayCount = element.pickupBallNumber;
          var sportMinute = int.parse(todayCount) * 60 / 70;
          var cal = sportMinute / 60 * 650 * weight/150;
          todayCal = cal.round();
         // print('今天消耗的卡路里${todayCal}');
        }
      });
    });
  }

  int getMaxValue(List<MyStatsModel> items) {
    return items.reduce((max, item) => max.speed > item.speed ? max : item).speed;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateCalorie(); // 卡片数据
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ActionListView(
                assetPath: 'images/connect/today_number_icon.png',
                title: 'Today',
                desc: "${widget.todayCount}"),
            ActionListView(
              assetPath: 'images/connect/today_use_time.png',
              title: 'Today Use',
              desc: '${widget.useMinutes}',
              unit: 'mins',
            ),
            // SizedBox(width: 20),
            ActionListView(
                assetPath: 'images/connect/today_cal.png',
                title: 'Calorie',
                desc: '${widget.todayCal}'),
          ],
        ),
      ],
    );
  }
}
