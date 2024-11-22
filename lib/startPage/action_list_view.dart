import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';

class ActionListView extends StatefulWidget {
  ActionListView(
      {this.assetPath,
      required this.title,
      required this.desc,
      this.code = 0,
      this.unit,
      this.showNext = false,this.onTap});

  bool showNext;
  String? assetPath;
  String title;
  String desc;
  String? unit;
  int code;
  Function? onTap;

  @override
  State<ActionListView> createState() => _ActionListViewState();
}

class _ActionListViewState extends State<ActionListView> {
  @override
  Widget build(BuildContext context) {
    return Container(

      width: (Constants.screenWidth(context)-20) / 3.0,
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
          Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color:Color.fromRGBO(49, 52, 67, 1),
            borderRadius: BorderRadius.circular(17)
          ),
          child: Center(child: Image(image: AssetImage(widget.assetPath ??
            'images/connect/today_number_icon.png'),width: 16,),)),
          SizedBox(height: 10,),
          Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                   Constants.boldWhiteTextWidget(widget.desc, 30,
                    height: 0.8),
                  widget.unit == null
                     ? Container() : Constants.mediumWhiteTextWidget(
                      widget.unit!, 10, Colors.white)
                ],
              ),
          ),
          SizedBox(height: 10,),

          Container(
              child: Text(
                    widget.title ?? '--',
                    style: TextStyle(
                        fontFamily: 'SanFranciscoDisplay',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Constants.grayTextColor),
                  ),
          ),
        ]
    ),);
  }
}
