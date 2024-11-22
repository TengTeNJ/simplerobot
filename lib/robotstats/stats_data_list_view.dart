import 'package:flutter/material.dart';
import 'package:tennis_robot/robotstats/stats_list_view.dart';

import '../startPage/action_list_view.dart';

/// 统计数据界面
class StatsDataListView extends StatefulWidget {
  String totalPickUpBallsCount = '0'; // 总的捡球个数
  String totalPickupBallTime = '0'; //总的捡球时间

  StatsDataListView({required this.totalPickUpBallsCount, required this.totalPickupBallTime});

  @override
  State<StatsDataListView> createState() => _StatsDataListViewState();
}

class _StatsDataListViewState extends State<StatsDataListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsListView(
                assetPath: 'images/connect/today_number_icon.png',
                title: 'Total',
                desc: "${widget.totalPickUpBallsCount}"),
            SizedBox(height: 32,),
            StatsListView(
              assetPath: 'images/connect/today_use_time.png',
              title: 'Total Use',
              desc: '${widget.totalPickupBallTime}',
              unit: 'mins',
            ),
          ],
        ),
      ],
    );
  }
}
