import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // 启动页延时 2 秒
      Thread.sleep(forTimeInterval: 2)
      
      GeneratedPluginRegistrant.register(with: self)
      let controller1: FlutterViewController = window?.rootViewController as! FlutterViewController
      let channe = FlutterMethodChannel(name: "com.example/native",
                                                binaryMessenger: controller1.binaryMessenger)
      
      
      let messenger: FlutterBinaryMessenger = window?.rootViewController as! any FlutterBinaryMessenger as FlutterBinaryMessenger
      testPlugin(messenger: messenger)
      
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
       let channel = FlutterMethodChannel(name: "native_screen", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { (call,result) in
          if call.method == "openNativeScreen" {// Flutter 打开原生界面
              if let isSkip = call.arguments as? Bool {
                  print("888888\(isSkip)")
                  self.openNativeScreen(message: messenger,isSkip: isSkip)

              }
          } else if call.method == "getNativeData" {
              let data = "Hello from Swift!"
              result(data)
          } else if call.method == "fLutterSendBattery" {
              if let battery = call.arguments as? String {
                  print("Received battery from Flutter: \(battery)")
                  let userInfo = ["message": "\(battery)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Battery), object: nil, userInfo: userInfo)

              }
              result(nil)
              
          } else if call.method == "RobotBallFullSingle" {
              print("收到FLutter机器人的球满指令了")

              if let battery = call.arguments as? String {
                  print("Received battery from Flutter: \(battery)")
                  let userInfo = ["message": "\(battery)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_Ball_Full), object: nil, userInfo: userInfo)

              }
              result(nil)
          } else if call.method == Constants.Notification_Robot_Begin_Navi {
              if let battery = call.arguments as? String {
                  print("Received battery from Flutter: \(battery)")
                  let userInfo = ["message": "\(battery)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_Begin_Navi), object: nil, userInfo: userInfo)

              }
              result(nil)
              
          } else if call.method == Constants.Notification_Robot_End_Navi { // 导航结束响应
              if let battery = call.arguments as? String {
                  let userInfo = ["message": "\(battery)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_End_Navi), object: nil, userInfo: userInfo)

              }
              result(nil)
          } else if call.method == Constants.Notification_Robot_Obstacle_Avoidance_End_Navi {
              if let battery = call.arguments as? String {
                  let userInfo = ["message": "\(battery)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_Obstacle_Avoidance_End_Navi), object: nil, userInfo: userInfo)

              }
              result(nil)
              
              
          } else if call.method == Constants.Notification_Robot_Bluetooth_Disconnect {
              NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_Bluetooth_Disconnect), object: nil, userInfo: nil)
              
          } else if call.method == Constants.Notification_Robot_Receive_StartOrStopSingle {
              if let type = call.arguments as? String {
                  let userInfo = ["message": "\(type)"]
                  NotificationCenter.default.post(name: Notification.Name(Constants.Notification_Robot_Receive_StartOrStopSingle), object: nil, userInfo: userInfo)
              }
              result(nil)
          } else if call.method == "fLutterSendMessage" {
              if let args = call.arguments as? String {
                  print("Received data from Flutter: \(args)")
              }
              result(nil)
          }
          
          else {
              result(FlutterMethodNotImplemented)
          }
          
    }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func openNativeScreen(message :FlutterBinaryMessenger,isSkip: Bool) {
        let nativeViewController = CameraCalibrationController(binaryMessenger: message)
        nativeViewController.isSkipGuidePage = isSkip
       let navigationController = UINavigationController(rootViewController: nativeViewController)
      if UIDevice.current.userInterfaceIdiom == .pad {
         navigationController.modalPresentationStyle = .fullScreen
       }
       let flutterViewController = window?.rootViewController as! FlutterViewController
       flutterViewController.present(navigationController, animated: true, completion: nil)
    }
    
    
   func testPlugin(messenger: FlutterBinaryMessenger) {
       let channel = FlutterMethodChannel(name: "plugin_apple", binaryMessenger: messenger)
       channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
       
           if (call.method == "apple_one") {
               result(["result":"success","code":200]);
           }
           
           if (call.method == "apple_two") {
               result(["result":"success","code":404]);
           }
    
       }
   }

}
