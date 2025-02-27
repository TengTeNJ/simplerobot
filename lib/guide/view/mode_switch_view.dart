import 'package:flutter/material.dart';

import '../../constant/constants.dart';

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
              borderRadius: BorderRadius.circular(18),
              color: Color.fromRGBO(19, 19, 20, 1),
            ),
            height: 36, width: 140,
          ),
          Positioned(
            left: 6,
            top: 4,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Constants.dialogBgColor : Constants.cameraPickBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                height: 28,
                width: 63,
                child: Container(
                  alignment: Alignment.center,
                  child:Constants.mediumWhiteTextWidget('Training', 15, _currentIndex == 0? Colors.white : Constants.grayTextColor),
                )
            ), ),
          ),
          Positioned(
              top: 4,
              right: 6,
              child: GestureDetector(onTap: () {
                if (widget.areaClick != null) {
                  widget.areaClick!(1);
                }
                _actionClick(1);

              }, child: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Constants.cameraPickBgColor : Constants.dialogBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),              height: 28, width: 63,

                child: Container(
                  alignment: Alignment.center,
                  child:Constants.mediumWhiteTextWidget('Rest', 15,_currentIndex == 0 ? Constants.grayTextColor : Colors.white),
                ),
              ),)
          ),
        ],
      ),
    );
  }
}
