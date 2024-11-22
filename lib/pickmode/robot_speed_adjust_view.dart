import 'package:flutter/material.dart';
import '../constant/constants.dart';

/// 收球轮速度调节View
class RobotSpeedAdjustView extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  Function? selectItem;

  RobotSpeedAdjustView({required this.leftTitle, required this.rightTitle , required this.selectItem});

  @override
  State<RobotSpeedAdjustView> createState() => _RobotSpeedAdjustViewState();
}

class _RobotSpeedAdjustViewState extends State<RobotSpeedAdjustView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            if (_currentIndex == 0) {
              return;
            }
            setState(() {
              _currentIndex = 0;
            });
            if (widget.selectItem != null) {
              print('0000${_currentIndex}');
              widget.selectItem!(_currentIndex);
            }
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? Color.fromRGBO(86, 45, 28, 1)
                    : Constants.dialogBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: _currentIndex == 0 ? Constants.selectedModelOrangeBgColor : Colors.transparent),
               // borderRadius: BorderRadius.circular(26)
            ),
            child: Center(
              child: Constants.customTextWidget(widget.leftTitle, 16,
                  _currentIndex == 0 ? '#E96415' : '#9C9C9C',
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        GestureDetector(
          onTap: () {
            if (_currentIndex == 1) {
              return;
            }
            setState(() {
              _currentIndex = 1;
            });
            if (widget.selectItem != null) {
              widget.selectItem!(_currentIndex);
            }
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: _currentIndex == 1
                    ? Color.fromRGBO(86, 45, 28, 1)
                    : Constants.dialogBgColor,
                // borderRadius: BorderRadius.circular(26)
              shape: BoxShape.circle,
              border: Border.all(color: _currentIndex == 1 ? Constants.selectedModelOrangeBgColor : Colors.transparent),
            ),
            child: Center(
              child: Constants.customTextWidget(widget.rightTitle, 16,
                  _currentIndex == 1 ? '#E96415' : '#9C9C9C',
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}
