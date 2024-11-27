import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../constant/constants.dart';

// 选项调节view
class SettingOptionAdjustView extends StatefulWidget {
  Function? areaClick;
  SettingOptionAdjustView({this.areaClick});

  @override
  State<SettingOptionAdjustView> createState() => _SettingOptionAdjustViewState();
}

class _SettingOptionAdjustViewState extends State<SettingOptionAdjustView> {
  int _currentIndex = 0;

  void _actionClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0.0, 0.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ClipRect(
            // borderRadius: BorderRadius.circular(32),
             Container(
              decoration: BoxDecoration(
                color: Constants.connectTextColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 20,
              width: 220,
            ),
          // ),
          Positioned(
            left:-10,
            top: -10,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
              Vibration.vibrate(duration: 500); // 触发震动
              print('1档');

            },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                     Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _currentIndex == 0 ? Constants.selectedModelOrangeBgColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color:_currentIndex == 0 ? Colors.white : Colors.transparent,width: 1 )
                      ),
                  ),
                  SizedBox(height: 12,),
                  Constants.regularWhiteTextWidget('1', 18, Constants.connectTextColor),
                ],

              ),
            ),
          ),

          Positioned(
            bottom:-36,
            right:-18 ,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(1);
              }
              print('2档');
              Vibration.vibrate(duration: 500); // 触发震动
              _actionClick(1);
            },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: _currentIndex == 1 ? Constants.selectedModelOrangeBgColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color:_currentIndex == 1 ? Colors.white : Colors.transparent,width: 1 )
                    ),
                  ),
                  SizedBox(height: 12,),
                  Constants.regularWhiteTextWidget('2', 18, Constants.connectTextColor),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }
}
