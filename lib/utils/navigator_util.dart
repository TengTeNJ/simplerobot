import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NavigatorUtil {
  static late BuildContext utilContext;

  // 设置NavigatorState，通常在应用启动时调用
  static void init(BuildContext context) {
    utilContext = context;
  }

  // 跳转到新页面（push）
  static push(String routeName,{Object arguments = const Object()}) {
    return Navigator.pushNamed(NavigatorUtil.utilContext, routeName,arguments: arguments);
  }

  // 跳转到新页面（context）
  static pushWithContext(String routeName,BuildContext context,{Object arguments = const Object()}) {
    return Navigator.pushNamed(context, routeName,arguments: arguments);
  }

  static pushAndThen(String routeName,{Object arguments = const Object()}) {
    //return Navigator.pushNamed(NavigatorUtil.utilContext, routeName,arguments: arguments);
    return Navigator.of(NavigatorUtil.utilContext).popAndPushNamed(routeName,arguments: arguments);
  }

  // 跳转到新界面（新页进来后，旧页销毁）
  static pushReplacementNamed(String routeName,{Object arguments = const Object()}) {
    return Navigator.pushReplacementNamed(
      NavigatorUtil.utilContext,
      routeName,
      arguments: arguments,
    );
  }

  static pushNamedAndRemoveUntil(String routeName,{Object arguments = const Object()}) {
   // return Navigator.of(NavigatorUtil.utilContext).pushNamedAndRemoveUntil(routeName, '/');
    return Navigator.pushNamedAndRemoveUntil(NavigatorUtil.utilContext, routeName, (route) => false);
  }
  
  //  出栈（pop）
  static pop() {
    return Navigator.of(NavigatorUtil.utilContext).pop();
  }

  // pop到root
  static popToRoot() {
    return Navigator.of(NavigatorUtil.utilContext).popUntil((route) => route.isFirst);
  }

  //  模态效果
  static present(Widget widget,{String routesName = '',Object arguments = const Object()}) async{
      showModalBottomSheet(
        isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
        context: NavigatorUtil.utilContext,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.95,
            child: widget,
          );
        },
      );

  }

}