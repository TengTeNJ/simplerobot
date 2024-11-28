import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/setting_balltype_list_view.dart';
import 'package:tennis_robot/setting/setting_button.dart';

import '../constant/constants.dart';
import '../utils/ble_send_util.dart';

class SettingBalltypeDataListView extends StatefulWidget {
  const SettingBalltypeDataListView({super.key});

  @override
  State<SettingBalltypeDataListView> createState() => _SettingBalltypeDataListViewState();
}

class _SettingBalltypeDataListViewState extends State<SettingBalltypeDataListView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(padding: EdgeInsets.only(top: 46,left: 16),
          child:Image(image: AssetImage(currentIndex == 0 ? 'images/profile/balltype_red_icon.png' :
          'images/profile/balltype_gray_icon.png'),width: 62,height: 62,),
        ),

        Padding(padding: EdgeInsets.only(top: 46,right: 24),
          child: SettingButton(title: 'Soft Ball',isSelected: currentIndex == 0? true : false,close: (){
            currentIndex = 0;
            BleSendUtil.setRobotCollectingWheelSpeed(1);
            setState(() {});

          },),
        )

      ],
      ),
        Container(
          margin: EdgeInsets.only(top: 20),
          width: Constants.screenWidth(context) - 40,
          height: 1,
          color: Color.fromRGBO(76, 78, 90, 1),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 46,left: 16),
              child:Image(image: AssetImage(currentIndex == 1 ? 'images/profile/balltype_yellow_icon.png' :
              'images/profile/balltype_gray_icon.png'),width: 62,height: 62,),
            ),
            Padding(padding: EdgeInsets.only(top: 46,right: 24),
              child: SettingButton(title: 'Hard Ball',isSelected: currentIndex == 1? true : false,close: (){
                       this.currentIndex = 1;
                       BleSendUtil.setRobotCollectingWheelSpeed(2);
                       setState(() {});
                },),
            )
          ],
        ),
      ],
    );
  }
}
