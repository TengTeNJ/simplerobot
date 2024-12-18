import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    //  child: Container(

          // borderRadius: BorderRadius.circular(20),
          child: Container(

            decoration: BoxDecoration(
              border: Border.all(color:widget.isSelected == true ? Color.fromRGBO(248, 98, 21, 1.0) : Colors.transparent),
              color: widget.isSelected == true ? Color.fromRGBO(86, 45, 28, 1): Constants.selectModelBgColor,
              borderRadius: BorderRadius.circular(20),
              
              //width: 1.0, // 边框宽度
            ),
            width: 96,
            height: 40,
            child: Container(
              width: 25,
              height: 25,
              child: Center(
                child: Constants.customTextWidget('${widget.title}', 16,widget.isSelected == true ?'#F86215' : "#9C9C9C"),
              ),
            ),
          ),
     // ),
    );
  }
}
