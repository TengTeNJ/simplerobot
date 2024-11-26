import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/string_util.dart';

import '../models/my_status_model.dart';

class MyStatsTipView extends StatefulWidget {
  MyStatsModel dataModel;
  MyStatsTipView({required this.dataModel});


  @override
  State<MyStatsTipView> createState() => _MyStatsTipViewState();
}

class _MyStatsTipViewState extends State<MyStatsTipView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(62, 62, 85, 1)),
      width: 60,
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(left: 4, top: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image(image: AssetImage('images/profile/stats_tennis.png'),width:8 ,height: 8,),
            Constants.customTextWidget('${widget.dataModel.speed}', 20, '#E96415',fontWeight:FontWeight.w700),
            Constants.customTextWidget('${StringUtil.stringToEnglishDate(widget.dataModel.gameTimer)}', 10, '#B1B1B1'),
            SizedBox(height: 4,)
          ],
        ),
      ),
    );
  }
}
