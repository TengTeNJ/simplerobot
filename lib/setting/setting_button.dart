import 'package:flutter/material.dart';
import 'package:tennis_robot/constant/constants.dart';
import '../utils/navigator_util.dart';

class SettingButton extends StatefulWidget {
  Function? close;
  String title;
  bool isSelected = false;

  SettingButton({this.close,required this.title,required this.isSelected});

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //NavigatorUtil.pop();
        if (widget.close != null) {
         widget.close!();
        }
        setState(() {});
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 96,
            height: 40,
            color: widget.isSelected == true ? Color.fromRGBO(86, 45, 28, 1): Constants.selectModelBgColor,
            child: Container(
              width: 25,
              height: 25,
              child: Center(
                child: Constants.customTextWidget('${widget.title}', 16,widget.isSelected == true ?'#F86215' : "#9C9C9C"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
