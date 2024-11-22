import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';

/// 模式切换view
class ModeSwitchView extends StatefulWidget {
  Function? areaClick;

  ModeSwitchView({this.areaClick});

  @override
  State<ModeSwitchView> createState() => _ModeSwitchViewState();
}

class _ModeSwitchViewState extends State<ModeSwitchView> {
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
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55/2),
              color: Constants.selectModelBgColor,
            ),
            height: 55, width: 206,
          ),
          Positioned(
            left: 5,
            top: 15/2,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Constants.selectedModelOrangeBgColor : Constants.selectModelBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 40,
                width: 90,
                child: Container(
                  alignment: Alignment.center,
                  // child:Constants.mediumWhiteTextWidget('Area A', 15, _currentIndex == 0? Colors.white : Constants.grayTextColor),
                  child: Image(width: 25,image: (AssetImage( _currentIndex == 0 ? 'images/home/pick_mode_select.png' : 'images/home/pick_mode.png')),),
                )
            ), ),
          ),
          Positioned(
              top: 15/2,
              right: 5,
              child: GestureDetector(onTap: () {
                if (widget.areaClick != null) {
                  widget.areaClick!(1);
                }
                _actionClick(1);

              }, child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Constants.selectModelBgColor : Constants.selectedModelOrangeBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),              height: 40, width: 90,

                child: Container(
                  alignment: Alignment.center,
                  child: Image(width: 25,image: (AssetImage(_currentIndex == 0 ? 'images/home/control_mode.png' : 'images/home/control_mode_select.png')),),
                ),
              ),)
          ),
        ],
      ),
    );
  }
}
