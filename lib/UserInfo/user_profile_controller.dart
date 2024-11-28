import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../utils/data_base.dart';
import '../utils/navigator_util.dart';

// 个人信息
class UserProfileController extends StatefulWidget {
  const UserProfileController({super.key});

  @override
  State<UserProfileController> createState() => _UserProfileControllerState();
}

class _UserProfileControllerState extends State<UserProfileController> {

  var nickName = '';
  var email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserInfo();
  }

  void checkUserInfo() async{
    var userInfo = await DataBaseHelper().fetchUserInfoData();
    if (userInfo == '') {
      print('没有用户信息');
    } else {
      List<String> info = userInfo.split('---');
      nickName = info.first;
      email = info.last;
      print('有用户信息${userInfo}');
    }
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
                   GestureDetector(onTap: () {
                     NavigatorUtil.pop();
                     },
                    child: Text('   Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(248, 98, 21, 1),
                        fontSize: 16,
                      ),
                    ),
                   ),
                    Constants.boldWhiteTextWidget('Profile', 22),
                    Text('')
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
                height: 183,
                width: 123,
                child: Image(
                  image: AssetImage('images/profile/user_profile_robot_icon.png'),
                  // fit: BoxFit.fill,
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 84,
                height: 32,
                margin: EdgeInsets.only(top: 0),
                child: Center(
                    child:
                    Constants.mediumWhiteTextWidget('S1ME01', 20, Colors.white)
                ),
              ),

              Container(
                width: Constants.screenWidth(context)- 140,
                height: 1,
                margin: EdgeInsets.only(top: 30),
                color: Color.fromRGBO(76, 78, 90, 1),
              ),

              SizedBox(height: 32,),
              Constants.regularWhiteTextWidget('NickName', 14, Constants.grayTextColor),

              SizedBox(height: 2,),

              Container(
                // width: Constants.screenWidth(context),
                // height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  children: [
                    Center(

                      // child: TextField(
                      //   cursorColor: Color.fromRGBO(248, 98, 21, 1),
                      //   controller: TextEditingController(),
                      //
                      //   style: TextStyle(color: Colors.white), // 设置字体颜色
                      //   decoration: InputDecoration(
                      //
                      //     hintText: '${nickName}',
                      //     hintStyle: TextStyle(
                      //       color: Color.fromRGBO(255, 255, 255, 1.0),
                      //       fontFamily: 'SanFranciscoDisplay',
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                     child:Constants.mediumWhiteTextWidget('${nickName}', 18, Colors.white),
                    ),
                   SizedBox(width: 8,),
                   GestureDetector(onTap: (){
                     print('1234');
                   },
                   child:Image(image: AssetImage('images/profile/user_edit_info_icon.png'),width: 13,),
                   )
                  ],

                ),
              ),
             // Constants.mediumWhiteTextWidget('${nickName}', 18, Colors.white),

              SizedBox(height: 32,),
              Constants.regularWhiteTextWidget('Email', 14, Constants.grayTextColor),

              SizedBox(height: 2,),
              Container(
                // width: Constants.screenWidth(context),
                // height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  children: [
                    Center(
                      child:Constants.mediumWhiteTextWidget('${email}', 18, Colors.white),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(onTap: (){
                      print('1234');
                    },
                      child:Image(image: AssetImage('images/profile/user_edit_info_icon.png'),width: 13,),
                    )
                  ],
                ),
              ),


             // Constants.mediumWhiteTextWidget('${email}', 18, Colors.white),

              SizedBox(height: 32,),
              Constants.regularWhiteTextWidget('Serial Number', 14, Constants.grayTextColor),

              SizedBox(height: 2,),
              Constants.mediumWhiteTextWidget('S1ME01', 18, Colors.white),

              SizedBox(height: 32,),
              Constants.regularWhiteTextWidget('Version', 14, Constants.grayTextColor),

              SizedBox(height: 2,),
              Constants.mediumWhiteTextWidget('1.1.1#000000', 18, Colors.white),
            ],

          ),
        ),
      ),
    );

  }
}
