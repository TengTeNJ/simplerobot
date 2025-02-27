import 'package:flutter/material.dart';

import '../../constant/constants.dart';

class ChooseModeBgview extends StatefulWidget {
  Function? areaClick;

  ChooseModeBgview({this.areaClick});

  @override
  State<ChooseModeBgview> createState() => _ChooseModeBgviewState();
}

class _ChooseModeBgviewState extends State<ChooseModeBgview> {
  int _currentIndex = 0;

  void _actionClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
     // alignment: const Alignment(0.0, 0.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.transparent,
            ),
            height: 266, width: 54 + 119 + 54 + 4 + 4 + 4,
          ),
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
                decoration: BoxDecoration(
                  color: Constants.cameraPickChooseAreaBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 266,
                width: 54,

            ), ),
          ),
          Positioned(
            left: 54 + 4,
            top: 0,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
              decoration: BoxDecoration(
                color: Constants.cameraPickChooseAreaBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 26,
              width: 119,
            ), ),
          ),

          Positioned(
            right: 4,
            top: 0,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
              decoration: BoxDecoration(
                color: Constants.cameraPickChooseAreaBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 266,
              width: 54,

            ), ),
          ),

          Positioned(
            left: 54 + 4,
            bottom: 0,
            child: GestureDetector(onTap: () {
              if (widget.areaClick != null) {
                widget.areaClick!(0);
              }
              _actionClick(0);
            },  child: Container(
              decoration: BoxDecoration(
                color: Constants.cameraPickChooseAreaBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 26,
              width: 119,
            ), ),
          ),


        ],
      ),
    );
  }
}
