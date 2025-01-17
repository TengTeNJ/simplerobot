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
  final TextEditingController _nickController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  // 计算文字宽高
  static Size boundingTextSize(BuildContext context, String text, TextStyle style,  {int maxLines = 2^31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        // locale: Localizations.localeOf(context, null Ok: true),
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    print('文字高度${textPainter.size.height}');
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.darkControllerColor,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GestureDetector(onTap: (){
          FocusScope.of(context).unfocus();
        },
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
                        var modifyNick = _nickController.text;
                        var modifyEmail = _emailController.text;
                        print('bbb${modifyNick}');
                        print('bbb${modifyEmail}');
                        if (modifyNick == '') {
                          modifyNick = nickName;
                        }
                        if (modifyEmail == '') {
                          modifyEmail = email;
                        }
                        // 更新用户信息
                        DataBaseHelper().saveUserInfoData('${modifyNick}---${modifyEmail}');
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
                      Constants.boldWhiteTextWidget('Profile', 22),
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
                  width: 183 ,
                  height: 123 ,
                  child: Image(
                    image: AssetImage('images/connect/robot.png'),
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

                SizedBox(height: 5,),

                Container(
                  // width: Constants.screenWidth(context),
                  // height: 200,
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center ,
                    children: [

                      Container(
                        height:26 ,
                        width: boundingTextSize(context, '${nickName}', TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'SanFranciscoDisplay')).width+8,
                        child: TextField(
                          cursorColor: Color.fromRGBO(248, 98, 21, 1),
                          onChanged: (value){
                            nickName = value;
                            setState(() {});
                          },
                          controller: _nickController,
                          style: TextStyle(color: Colors.white), // 设置字体颜色
                          decoration: InputDecoration(
                            border: InputBorder.none, // 移除边框
                            hintText: '${nickName}',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent), // 设置焦点时的边框颜色
                            ),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1.0),
                                fontFamily: 'SanFranciscoDisplay',
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        // child:Constants.mediumWhiteTextWidget('${nickName}', 18, Colors.white),
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

                SizedBox(height: 5,),
                Container(
                  // width: Constants.screenWidth(context),
                  // height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center ,
                    children: [
                      Container(
                        height:22 ,
                        width: boundingTextSize(context, '${email}', TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'SanFranciscoDisplay')).width + 8,
                        child: TextField(
                          cursorColor: Color.fromRGBO(248, 98, 21, 1),
                          onChanged: (value){
                            email = value;
                            setState(() {});
                          },
                          controller: _emailController,
                          style: TextStyle(color: Colors.white), // 设置字体颜色
                          decoration: InputDecoration(
                            border: InputBorder.none, // 移除边框
                            hintText: '${email}',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent), // 设置焦点时的边框颜色
                            ),
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1.0),
                                fontFamily: 'SanFranciscoDisplay',
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        // child:Constants.mediumWhiteTextWidget('${email}', 18, Colors.white),
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

      ),
    );

  }
}