import 'package:flutter/material.dart';
import 'package:tennis_robot/setting/setting_balltype_data_list_view.dart';
import 'package:tennis_robot/utils/data_base.dart';

import '../constant/constants.dart';
import '../utils/navigator_util.dart';

// 设置球的类型
class SettingBallTypeController extends StatefulWidget {
  const SettingBallTypeController({super.key});

  @override
  State<SettingBallTypeController> createState() => _SettingBallTypeControllerState();
}

class _SettingBallTypeControllerState extends State<SettingBallTypeController> {

  int _currentBallType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDBBallTYpeData();
  }

  Future<void> getDBBallTYpeData () async {
    _currentBallType = await DataBaseHelper().fetchBallTypeData();
    print('balltype 888 ${_currentBallType}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.darkControllerColor,
      body: ClipRRect(
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

              SettingBalltypeDataListView(currentIndex: _currentBallType,)
            ],

          ),
        ),
      ),
    );
  }
}
