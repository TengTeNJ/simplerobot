import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../utils/navigator_util.dart';

class FaultInfoController extends StatefulWidget {
  const FaultInfoController({super.key});

  @override
  State<FaultInfoController> createState() => _FaultInfoControllerState();
}

class _FaultInfoControllerState extends State<FaultInfoController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Constants.darkControllerColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
         width:Constants.screenWidth(context),
         color: Constants.dialogBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 36,
                margin: EdgeInsets.only(right: 16, top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: (){
                      NavigatorUtil.pop();
                    },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        color:  Constants.dialogBgColor,
                        width: 100,
                        child: Text('Back',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(248, 98, 21, 1),
                            fontSize: 16,
                          ),
                        ),
                      ),),
                    Constants.boldWhiteTextWidget('Fault', 22),
                    Constants.mediumWhiteTextWidget('123456', 16, Constants.dialogBgColor),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                width:  Constants.screenWidth(context),
                height: 1,
                color: Color.fromRGBO(86, 89, 101, 1),
              ),

              SizedBox(width: Constants.screenWidth(context),height: 30,),
              
              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('Faults and Solutions', 18, Colors.white,maxLines: 3 ,height: 1.1),
              ),


              /// 球网
              SizedBox(height: 54,),

              Container(
                width: 90,
                margin: EdgeInsets.only(top: 10),
                height: 90,
                decoration: BoxDecoration(
                    color:Color.fromRGBO(28, 29, 32, 1),
                    borderRadius: BorderRadius.circular(45)
                ),
                  child: Center(child: Image(image: AssetImage(''
                      'images/fault/fault_web.png'),width: 64,height: 50,),)
              ),

              SizedBox(height: 13,),


              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('1.Faults and Solutions', 16, Colors.white,maxLines: 3 ,
                    height: 1.1),
              ),

              SizedBox(height: 12,),
              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('Solution: \nDetach the net from the SeekerBot\n and restart the machine.', 16,
                    Color.fromRGBO(248, 98, 21, 1),maxLines: 3 ,
                    height: 1.1),
              ),
              /// 避障 90度
              ///
              SizedBox(height: 54,),

              Container(
                  width: 90,
                  margin: EdgeInsets.only(top: 10),
                  height: 90,
                  decoration: BoxDecoration(
                      color:Color.fromRGBO(28, 29, 32, 1),
                      borderRadius: BorderRadius.circular(45)
                  ),
                  child: Center(child: Image(image: AssetImage(''
                      'images/fault/fault_jiao.png'),width: 64,height: 50,),)
              ),

              SizedBox(height: 13,),


              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('2.Stuck in Tight Right-Angled Space', 16, Colors.white,maxLines: 3 ,
                    height: 1.1),
              ),

              SizedBox(height: 12,),
              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('Solution:\n Switch to manual mode and guide the SeekerBot out of the area.', 16,
                    Color.fromRGBO(248, 98, 21, 1),maxLines: 3 ,
                    height: 1.1),
              ),

              /// 收球轮速度
              SizedBox(height: 54,),

              Container(
                  width: 90,
                  margin: EdgeInsets.only(top: 10),
                  height: 90,
                  decoration: BoxDecoration(
                      color:Color.fromRGBO(28, 29, 32, 1),
                      borderRadius: BorderRadius.circular(45)
                  ),
                  child: Center(child: Image(image: AssetImage(''
                      'images/fault/fault_roller.png'),width: 64,height: 50,),)
              ),

              SizedBox(height: 13,),


              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('03.Wheel Obstructed', 16, Colors.white,maxLines: 3 ,
                    height: 1.1),
              ),

              SizedBox(height: 12,),
              Container(
                width: Constants.screenWidth(context) - 52*2,
                child: Constants.mediumWhiteTextWidget('Solution: \nInspect the wheels for foreign objects or any object sticking out and remove the obstructions.', 16,
                    Color.fromRGBO(248, 98, 21, 1),maxLines: 4 ,
                    height: 1.1),
              ),
              SizedBox(height: 24,),

            ],

          ),
        ),
      ),
    );

  }
}
