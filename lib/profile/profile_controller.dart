import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/models/language_model.dart';
import 'package:tennis_robot/profile/setting_list_view.dart';
import '../models/setting_model.dart';
import '../utils/blue_tooth_manager.dart';
import '../utils/dialog.dart';
import '../utils/event_bus.dart';
import '../utils/navigator_util.dart';

class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  // List<SettingModel> data = [
  //   // ${Provider.of<LanguageModel>(context,listen: false).getText('跳过')}
  //   SettingModel('images/profile/setting_ball_type.png','${Provider.of<LanguageModel>(context,listen: false).getText('收球类型')}'),
  //   SettingModel('images/profile/setting_roller_speed.png','${Provider.of<LanguageModel>(context,listen: false).getText('车轮速度')}'),
  //   // SettingModel('images/profile/setting_reset_gap.png','Reset Gap'),
  //   SettingModel('images/profile/setting_profile.png','${Provider.of<LanguageModel>(context,listen: false).getText('个人资料')}'),
  //   SettingModel('images/profile/setting_fault.png','${Provider.of<LanguageModel>(context,listen: false).getText('故障引导')}'),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 断链退到连接界面
    BluetoothManager().disConnect = () {
      TTDialog.robotBleDisconnectDialog(context, () async {
        // 发送通知到连接界面
        EventBus().sendEvent(kRobotConnectChange);
        NavigatorUtil.popToRoot();
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    final languageModel = Provider.of<LanguageModel>(context);
    List<SettingModel> data = [
      SettingModel('images/profile/setting_ball_type.png','${Provider.of<LanguageModel>(context,listen: false).getText('收球类型')}'),
      SettingModel('images/profile/setting_roller_speed.png','${Provider.of<LanguageModel>(context,listen: false).getText('车轮速度')}'),
      // SettingModel('images/profile/setting_reset_gap.png','Reset Gap'),
      SettingModel('images/profile/setting_profile.png','${Provider.of<LanguageModel>(context,listen: false).getText('个人资料')}'),
      SettingModel('images/profile/setting_fault.png','${Provider.of<LanguageModel>(context,listen: false).getText('故障引导')}'),
    ];



    return Scaffold(
      body: Container(
        color: Constants.darkControllerColor,
         child: Column(
           children: [
             Container(
               width: Constants.screenWidth(context),
               margin: EdgeInsets.only(top: 55,left: 24),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 // crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   GestureDetector(onTap: (){
                    NavigatorUtil.pop();
                     },
                     child: Container(
                     //  padding: EdgeInsets.all(12.0),
                       padding: EdgeInsets.only(left: 0,top: 12,bottom: 12,right: 24),
                       color:  Constants.darkControllerColor,
                       width: 48,
                       height: 48,
                       child: Image(
                           width:24,
                           height: 24,
                           image: AssetImage('images/base/back.png'),
                         ),
                     ),
                   ),
                   Text('SETTINGS',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontFamily: 'tengxun',
                       color: Colors.white,
                       fontSize: 22,
                     ),
                   ),
                   Text('123456')
                 ],
               ),
             ),
             // Container(
             //   margin: EdgeInsets.only(top: 40),
             //   child: ProfileDataListView() ,
             // ),

             Expanded(child:
             Container(
               // child: Padding(padding: EdgeInsets.only(left: 24, right: 24),
                 child: SettingListView(datas: data,),
               )

             // ),
             )
           ]
         ),
      ),
    );
  }

}
