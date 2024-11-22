import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';


class StatsListView extends StatefulWidget {
  StatsListView(
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
  State<StatsListView> createState() => _StatsListViewState();
}

class _StatsListViewState extends State<StatsListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: (Constants.screenWidth(context) - 32) / 2.0 - 50,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                if(widget.onTap != null){
                  widget.onTap!();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Constants.boldWhiteTextWidget(widget.desc, 36,
                            height: 0.8),
                        SizedBox(
                          width: 2,
                        ),
                        widget.unit == null
                            ? Container()
                            : Constants.mediumWhiteTextWidget(
                            widget.unit!, 10, Colors.white)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28, top:20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //margin: EdgeInsets.only(top: 14),
                  child: Image(
                    image: AssetImage(widget.assetPath ??
                        'images/connect/today_number_icon.png'),
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  widget.title ?? '--',
                  style: TextStyle(
                      fontFamily: 'SanFranciscoDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Constants.grayTextColor),
                ),],
            ),
          ),
        ],
      ),
    );
  }
}
