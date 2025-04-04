import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/slider_view.dart';

import '../constant/constants.dart';
import '../utils/navigator_util.dart';


/// 新的界面 设置ball Type
class NewSettingBallTypeController extends StatefulWidget {
  const NewSettingBallTypeController({super.key});

  @override
  State<NewSettingBallTypeController> createState() => _NewSettingBallTypeControllerState();
}

class _NewSettingBallTypeControllerState extends State<NewSettingBallTypeController> {
  String chooseValue = "60";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.darkControllerColor,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width:Constants.screenWidth(context),
          height: Constants.screenHeight(context),
          color: Constants.dialogBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 36,
                margin: EdgeInsets.only(right: 16, top: 16),
                child: Row(
                  //  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: (){
                      NavigatorUtil.pop();
                    },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        color:  Constants.dialogBgColor,
                        width: 100,
                        child: Text('Save',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(248, 98, 21, 1),
                            fontSize: 16,
                          ),
                        ),
                      ),),

                    Constants.boldWhiteTextWidget('Ball Type', 22),
                    Constants.mediumWhiteTextWidget('123456', 16, Constants.dialogBgColor),

                  ],
                ),
              ),
              SizedBox(width: Constants.screenWidth(context),height: 1,),

              Container(
                margin: EdgeInsets.only(top: 20),
                width:  Constants.screenWidth(context),
                height: 1,
                color: Color.fromRGBO(86, 89, 101, 1),
              ),

              Container(
                margin: EdgeInsets.only(top: 60),
                height: 97,
                width: 97,
                child: Image(
                  image: AssetImage('images/setting/ball.png'),
                  fit: BoxFit.fill,
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 34),
                child: Center(
                  child:
                    Constants.mediumWhiteTextWidget("${chooseValue}kpa", 18, Constants.selectedModelBgColor)
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 8),
                width: Constants.screenWidth(context) ,
                height: 50,
                child: SliderView(defaultValue: 65.0,chooseValue: (value){
                    setState(() {
                      chooseValue = value.toInt().toString();
                    });
                },),
              ),

              Container(
                // color: Colors.red,
                width: Constants.screenWidth(context) - 140,
                // margin: EdgeInsets.only(left: 70 ,right: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.mediumWhiteTextWidget('Soft', 18, Constants.connectTextColor),
                    Constants.mediumWhiteTextWidget('Hard', 18, Constants.connectTextColor ),
                  ],
                ),
              ),

              SizedBox(height: 28,),
            ],
          ),
        ),
      ),
    );

  }
}
