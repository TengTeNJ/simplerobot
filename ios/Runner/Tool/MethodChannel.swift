//
//  MethodChannel.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/6.
//

import UIKit
import Flutter

/// Flutter 与Swift 通信
class MethodChannel: NSObject {
  var count = 6
  var channel:FlutterMethodChannel
  init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "com.flutter.guide.MethodChannel", binaryMessenger: messenger)
        channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
//            if (call.method == "sendData") {
//                if let dict = call.arguments as? Dictionary {
//                    let name:String = dict["name"] as? String ?? ""
//                    let age:Int = dict["age"] as? Int ?? -1
//                    result(["name":"hello,\(name)","age":age])
//                }
//            }
        }
      var args = ["count":count]
      channel.invokeMethod("timer", arguments:args)
       // startTimer()
    }
   
    
    
}
