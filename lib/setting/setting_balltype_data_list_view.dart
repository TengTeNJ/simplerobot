import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/setting_button.dart';

import '../constant/constants.dart';
import '../utils/ble_send_util.dart';
import '../utils/data_base.dart';

class SettingBalltypeDataListView extends StatefulWidget {
  int currentIndex = 0;

  SettingBalltypeDataListView({required this.currentIndex});

  @override
  State<SettingBalltypeDataListView> createState() => _SettingBalltypeDataListViewState();
}

class _SettingBalltypeDataListViewState extends State<SettingBalltypeDataListView> {
 // int currentIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(top: 46,left: 50),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Image(image: AssetImage(widget.currentIndex == 0 ? 'images/profile/balltype_red_icon.png' :
                'images/profile/balltype_gray_icon.png'),width: 62,height: 62,),
               SizedBox(height: 10,),
               Constants.regularWhiteTextWidget('70 kPa', 15, widget.currentIndex == 0 ? Colors.white :Constants.grayTextColor),
             ],
            ),
        ),

        Padding(padding: EdgeInsets.only(top: 46,right: 50),
          child: SettingButton(title: 'Soft',isSelected: widget.currentIndex == 0? true : false,close: (){
            widget.currentIndex = 0;
            BleSendUtil.setRobotCollectingWheelSpeed(1);
            DataBaseHelper().saveBallTypeData(widget.currentIndex);
            setState(() {});

          },),
        )
        ],
      ),
        Container(
          margin: EdgeInsets.only(top: 42),
          width: Constants.screenWidth(context) - 40,
          height: 1,
          color: Color.fromRGBO(76, 78, 90, 1),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 46,left: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage(widget.currentIndex == 1 ? 'images/profile/balltype_yellow_icon.png' :
                    'images/profile/balltype_gray_icon.png'),width: 62,height: 62,),
                  SizedBox(height: 10,),
                  Constants.regularWhiteTextWidget('60 kPa', 15,widget.currentIndex == 1 ? Colors.white :Constants.grayTextColor),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 46,right: 50),
              child: SettingButton(title: 'Hard',isSelected:widget.currentIndex == 1? true : false,close: (){
                       widget.currentIndex = 1;
                       BleSendUtil.setRobotCollectingWheelSpeed(2);
                       DataBaseHelper().saveBallTypeData(widget.currentIndex);
                       setState(() {});
                },),
            )
          ],
        ),
      ],
    );
  }
}
