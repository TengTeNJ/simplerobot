/*机器人状态*/
import 'ball_model.dart';

enum RobotStatu {
  standby, // 待机
  ready, // 就绪
  work, // 工作中
  error // 故障
}

/*机器人运行模式*/
enum RobotMode {
  rest, // 休息模式(0 -- )
  training, // 训练模式 (1 -- 传给FLy 的模式的值)
  remote, // 遥控模式(2 -- )
  onepick // 1.0的捡球模式 (3 -- )

}

/*机器人避障距离 */
enum RobotAvoidanceDistance {
  near, // 近距离
  far // 远距离
}

/*机器人捡满50个球休息间隔设置 */
enum RobotResetGap {
  zero, // 0 分钟
  one, // 1 分钟
  three // 6 分钟
}

/*机器人速度 */
enum RobotSpeed {
  slow, // 低速
  fast, // 高速
  faster // 超高速
}

class RobotDataModel {
  bool powerOn = false; // 开关机状态
  int powerValue = 100; // 电量值
  RobotStatu statu = RobotStatu.standby; // 机器人状态
  int warnStatu = 0; // 机器人告警信息 0 无告警,1 卡停告警,2 手环信号丢失告警,3 电池电量低告警
  int errorStatu = 0; // 机器人故障信息 0 无故障, 1 收球轮异常故障,2 行走轮异常故障, 3 摄像头异常故障 4 雷达异常故障
  RobotMode mode = RobotMode.rest;
  int area = 0; // 机器人区域 0 A区域，1 B区域
  int xPoint = 0; // 机器人X坐标
  int yPoint = 0; // 机器Y坐标
  int angle = 0; // 机器人角度
  int speed = 0; // 机器人速度
  List<BallModel> inViewBallList = [];// 视野中看到的所有的球
  int navigationEndType = 0 ; // 导航结束的类型 1 原点已停止  2 区域位置到达
  int responseStartStopType = 2 ; // 机器人应答start,stop成功  0 stop  1 start

}
//   int warnStatu = 0; // 机器人告警信息 0 无告警,1 卡停告警,2 手环信号丢失告警,3 电池电量低告警  暂无
//   int errorStatu = 0;  1 收球轮异常故障,2 行走轮异常故障, 3 摄像头异常故障 4 雷达异常故障
//   球的坐标是厘米相对于机器人的
