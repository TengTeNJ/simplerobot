import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tennis_robot/utils/string_util.dart';

import '../constant/constants.dart';
import '../route/routes.dart';
import '../utils/navigator_util.dart';

// 用户信息收集界面
class UserInfoInputController extends StatefulWidget {
  const UserInfoInputController({super.key});

  @override
  State<UserInfoInputController> createState() => _UserInfoInputControllerState();
}

class _UserInfoInputControllerState extends State<UserInfoInputController> {
  bool isConnected = false; // 是否
  final TextEditingController _nickController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.darkControllerColor,
        body: SingleChildScrollView(
          child: ClipRect(
            child: Container(
              color: Constants.darkControllerColor,
              child: Column(
                children: [
                  Container(
                    height: 171,
                    width: 257,
                    margin: EdgeInsets.only(top: 167),
                    child: Image(
                      image: AssetImage('images/connect/robot.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 70, right: 44, top: 50),
                    child: Constants.regularWhiteTextWidget('NickName', 18, Colors.white,textAlign: TextAlign.left),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 70, right: 44, top: 4),
                    height:44 ,
                    child: TextField(
                      cursorColor: Color.fromRGBO(248, 98, 21, 1),
                      onChanged:(value) {
                        if (_emailController.text != '' && _nickController.text != ''){
                          setState(() {
                            isConnected = true;
                          });
                        } else {
                          setState(() {
                            isConnected = false;
                          });
                        }
                      },
                      controller: _nickController,
                      style: TextStyle(color: Constants.baseStyleColor), // 设置字体颜色
                      decoration: InputDecoration(
                        hintText: 'Enter Nickname', // 占位符文本
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(248, 98, 21, 1)), // 设置焦点时的边框颜色
                        ),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(156, 156, 156, 1.0),
                            fontFamily: 'SanFranciscoDisplay',
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),


                    ),
                  ),

                  Container(
                    // color: Colors.red,
                    width: Constants.screenWidth(context),
                    margin: EdgeInsets.only(left: 70, right: 44, top: 40),
                    child: Constants.regularWhiteTextWidget('Email', 18, Colors.white,textAlign: TextAlign.left),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 70, right: 44, top: 4),
                    height:44 ,
                    child: TextField(
                      onChanged:(value) {
                        if (_emailController.text != '' && _nickController.text != ''){
                          setState(() {
                            isConnected = true;
                          });
                        } else {
                          setState(() {
                            isConnected = false;
                          });
                        }
                      },
                      controller: _emailController,
                      cursorColor: Color.fromRGBO(248, 98, 21, 1),
                      style: TextStyle(color: Constants.baseStyleColor), // 设置字体颜色
                      decoration: InputDecoration(
                        hintText: 'Enter Email', // 占位符文本
                        focusColor: Colors.red,
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.white), // 设置焦点之外的边框颜色
                        // ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(248, 98, 21, 1)), // 设置焦点时的边框颜色
                        ),


                        hintStyle: TextStyle(
                            color: Color.fromRGBO(156, 156, 156, 1.0),
                            fontFamily: 'SanFranciscoDisplay',
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                  GestureDetector(onTap: (){
                    var nick = _nickController.text;
                    var email = _emailController.text;
                    if (!StringUtil.isValidEmail(email)) {
                      // EasyLoading.showSuccess('Please enter a valid email');
                      // EasyLoading.showInfo('Please enter a valid email');
                      EasyLoading.showError('Please enter a valid email');
                      return;
                    }
                    NavigatorUtil.push(Routes.action);
                  },
                  child: Container(
                      child: Center(
                      child: Constants.mediumWhiteTextWidget(
                      'Start', 20,isConnected ? Colors.white : Constants.grayTextColor),
            ),
            height: 72,
            margin: EdgeInsets.only(left: 44, right: 44, top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: isConnected ? Constants.selectedModelOrangeBgColor : Constants.selectModelBgColor ,
            ),
          ),
        ),


      SizedBox(height: 30),
                ],
              ),
            ),
          ),
        )
    );

  }
}
