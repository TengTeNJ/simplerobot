// import 'package:code/views/dialog/dialog.dart';
import 'package:tennis_robot/utils/cancel_button.dart';
import 'package:tennis_robot/utils/color.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/utils/base_button.dart';
import 'package:flutter/material.dart';
import 'package:tennis_robot/utils/toast.dart';
import 'string_util.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'navigator_util.dart';

class TTDialog {
  /* 机器人结束任务弹窗*/
  static robotEndTaskDialog(BuildContext context, Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: RobotEndTaskDialog(exchange: exchange),
            ),
          );
        }
    );
  }

  static robotEXceptionDialog(BuildContext context,String title,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotExceptionDialog(exchange: exchange,title: title),
            ),
          );
        }
    );

  }

  static robotModeAlertDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotModelAlertDialog(exchange: exchange),
            ),
          );
        }
    );

  }
  // 低电量提醒
  static robotLowBatteryDialog(BuildContext context,Function exchange,{
    int currentBattery = 20}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Low Battery',descTitle: '${currentBattery}% battery remaining Please recharge your Bot',imgName: 'images/base/low_battery.png',),
            ),
          );
        }
    );
  }
  // 蓝牙断链提醒
  static robotBleDisconnectDialog(BuildContext context,Function exchange) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Bluetooth Disconnected',descTitle: 'Bluetooth disconnected Please check your Bot',imgName: 'images/base/ble_disconnect.png',),
            ),
          );
        }
    );
  }

  // 卡停提醒
  static robotRobotStopDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Stuck',descTitle: 'The Bot is Stuck Please check your Bot',imgName: 'images/base/stop_alarm.png',),
            ),
          );
        }
    );
  }

  // 连接失败
  static robotRobotConnectFailDialog(BuildContext context,Function exchange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotConnectFailedDialog(exchange: exchange, title: 'Connection Failed',descTitle: 'Failed to connect to device \n"Seekerbot".\n Check for issues and try again.',imgName: 'images/base/connect_fail.png',),
            ),
          );
        }
    );
  }

  // 结束任务提醒
  static robotEndTask(BuildContext context,Function exchange) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Finish',descTitle: 'Seekerbot will stop working',imgName: 'images/base/robot_end_task.png',),
            ),
          );
        }
    );
  }

  // 死角提示
  static robotBlindCornerPrompt(BuildContext context,Function exchange) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Stuck',descTitle: 'The Bot is Stuck Please check your Bot',imgName: 'images/base/ble_disconnect.png',),
            ),
          );
        }
    );
  }

 // 缠绕提示
  static robotWrapPrompt(BuildContext context,Function exchange) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                // color: hexStringToColor('#3E3E55'),
                color: Constants.dialogBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:RobotLowBatteryDialog(exchange: exchange, title: 'Stuck',descTitle: 'The Bot is Stuck Please check your Bot',imgName: 'images/base/ble_disconnect.png',),
            ),
          );
        }
    );
  }


  // 日期选择器
  static timeSelect(BuildContext context, Function confirm,
      {int index = 0, String? start, String? end}) {
    showModalBottomSheet(
      backgroundColor: hexStringToColor('#3E3E55'),
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: context,
      builder: (BuildContext context) {
        double _height = 0.5;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: _height,
                child: TimeSelectDialog(
                  startTime: start,
                  endTime: end,
                  selectIndex: index,
                  datePickerSelect: (value) {
                    if (value) {
                      _height = 0.80;
                      setState(() {});
                    } else {
                      _height = 0.5;
                      setState(() {});
                    }
                  },
                  confirm: (startTime, endTime, selectIndex) {
                    if (confirm != null) {
                      int _index = selectIndex;
                      if (selectIndex == -1) {
                        _index = 3;
                      }
                      confirm(startTime, endTime, _index);
                    }
                  },
                ),
              );
            });
      },
    );
  }
}

/*时间选择弹窗*/
class TimeSelectDialog extends StatefulWidget {
  String? startTime;
  String? endTime;
  int selectIndex; // 标识选择的时7,30 还是90days
  Function? datePickerSelect;
  Function? confirm;

  TimeSelectDialog(
      {this.datePickerSelect,
        this.confirm,
        this.selectIndex = 0,
        this.startTime,
        this.endTime});

  @override
  State<TimeSelectDialog> createState() => _TimeSelectDialogState();
}

class _TimeSelectDialogState extends State<TimeSelectDialog> {
  int _selectIndex = 0;
  int _timeSelectIndex = 0; // 当选择自定义时，标记选择的时开始还是结束 1开始 2结束
  DateTime _selectedDate = DateTime.now();
  DateTime _maxDate = DateTime.now();
  late DateTime _yesterdayDate;

  late String startTime;
  late String endTimer;

  // 计算90天前的时间
  late DateTime _minDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectIndex = widget.selectIndex;
    _minDate = _selectedDate.subtract(Duration(days: 180));
    // 昨天的时间
    DateTime yesterday = _selectedDate.subtract(Duration(days: 1));
    _yesterdayDate = yesterday;
    endTimer = widget.endTime != null
        ? widget.endTime!
        : StringUtil.dateToString(yesterday);
    // 过去七天的第一天的时间
    DateTime beforeSeven = yesterday.subtract(Duration(days: 7));
    startTime = widget.startTime != null
        ? widget.startTime!
        : StringUtil.dateToString(beforeSeven);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CancelButton()],
            ),
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 7days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 0;

                      DateTime yesterday =
                      _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去七天的第一天的时间
                      DateTime beforeSeven =
                      _yesterdayDate.subtract(Duration(days: 7));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 0
                                ? Border.all(
                              color: hexStringToColor('#707070'),
                              width: 0.0, // 设置边框宽度
                            )
                                : Border.all(
                              color: hexStringToColor('#707070'),
                              width: 1.0, // 设置边框宽度
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 0
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 0
                              ? Constants.regularWhiteTextWidget(
                              'Last 7 days', 14,Colors.white)
                              : Constants.regularGreyTextWidget(
                              'Last 7 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 30days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 1;
                      DateTime yesterday =
                      _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去30天的第一天的时间
                      DateTime beforeSeven =
                      _yesterdayDate.subtract(Duration(days: 30));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 1
                                ? Border.all(
                              color: hexStringToColor('#707070'),
                              width: 0.0, // 设置边框宽度
                            )
                                : Border.all(
                              color: hexStringToColor('#707070'),
                              width: 1.0, // 设置边框宽度
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 1
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 1
                              ? Constants.regularWhiteTextWidget(
                              'Last 30 days', 14,Colors.white)
                              : Constants.regularGreyTextWidget(
                              'Last 30 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Last 90days
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      _timeSelectIndex = 0;
                      _selectIndex = 2;
                      DateTime yesterday =
                      _selectedDate.subtract(Duration(days: 1));
                      _yesterdayDate = yesterday;
                      endTimer = StringUtil.dateToString(yesterday);
                      // 过去90天的第一天的时间
                      DateTime beforeSeven =
                      _yesterdayDate.subtract(Duration(days: 90));
                      startTime = StringUtil.dateToString(beforeSeven);
                      setState(() {});
                    },
                    child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                            border: _selectIndex == 2
                                ? Border.all(
                              color: hexStringToColor('#707070'),
                              width: 0.0, // 设置边框宽度
                            )
                                : Border.all(
                              color: hexStringToColor('#707070'),
                              width: 1.0, // 设置边框宽度
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: _selectIndex == 2
                                ? Constants.baseStyleColor
                                : hexStringToColor('#3E3E55')),
                        child: Center(
                          child: _selectIndex == 2
                              ? Constants.regularWhiteTextWidget(
                              'Last 90 days', 14,Colors.white)
                              : Constants.regularGreyTextWidget(
                              'Last 90 days', 14),
                        )),
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 1) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});

                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(startTime);
                      _timeSelectIndex = 1;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(startTime, 16,Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 1
                              ? Icon(
                            Icons.keyboard_arrow_down,
                            color: Constants.baseStyleColor,
                          )
                              : Icon(
                            Icons.chevron_right,
                            color: Constants.baseGreyStyleColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: hexStringToColor('#707070'),
                        height: 0.5,
                        width: (Constants.screenWidth(context) - 90) / 2.0,
                      )
                    ],
                  ),
                ),
                Constants.regularGreyTextWidget('To', 14, height: 0.8),
                GestureDetector(
                  onTap: () {
                    if (_timeSelectIndex == 2) {
                      _timeSelectIndex = 0;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(false);
                      }
                      setState(() {});
                      return;
                    }
                    _selectIndex = -1;
                    _timeSelectIndex = 0; // 如果时间选择弹窗正在显示，先让收起
                    setState(() {});
                    Future.delayed(Duration(milliseconds: 100), () {
                      _selectedDate = StringUtil.stringToDate(endTimer);
                      _timeSelectIndex = 2;
                      if (widget.datePickerSelect != null) {
                        widget.datePickerSelect!(true);
                      }
                      setState(() {});
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(endTimer, 16,Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          _timeSelectIndex == 2
                              ? Icon(
                            Icons.keyboard_arrow_down,
                            color: Constants.baseStyleColor,
                          )
                              : Icon(
                            Icons.chevron_right,
                            color: Constants.baseGreyStyleColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: hexStringToColor('#707070'),
                        height: 0.5,
                        width: (Constants.screenWidth(context) - 90) / 2.0,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help,
                  color: hexStringToColor('#B1B1B1'),
                  size: 12,
                ),
                SizedBox(
                  width: 4,
                ),
                Constants.regularGreyTextWidget(
                    'Only six months of data are available', 10),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            _timeSelectIndex >= 1
                ? Container(
              color: Colors.red,
              height: 220,
              child: Center(
                  child: DateTimePickerWidget(
                    onChange: (DateTime dateTime, List<int> selectedIndex) {
                      if (_timeSelectIndex == 1) {
                        startTime = StringUtil.dateToString(dateTime);
                      } else if (_timeSelectIndex == 2) {
                        endTimer = StringUtil.dateToString(dateTime);
                      }
                      setState(() {});
                    },
                    pickerTheme: DateTimePickerTheme(
                        itemTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'SanFranciscoDisplay'),
                        backgroundColor: hexStringToColor('#3E3E55'),
                        titleHeight: 0,
                        itemHeight: 44,
                        pickerHeight: 220),
                    minDateTime: _minDate,
                    maxDateTime: _maxDate,
                    initDateTime: _selectedDate,
                    locale: DateTimePickerLocale.en_us,
                    dateFormat:
                    'MMM-dd-yyyy', // 这里的MMMM4个显示引英文全写，两个的话仍然显示数字月份.3个的话显示缩写的英文月份
                  )),
            ) // 时间弹窗
                : Container(),
            _timeSelectIndex >= 1
                ? SizedBox(
              height: 16,
            )
                : SizedBox(
              height: 0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                DateTime startDate = StringUtil.stringToDate(startTime);
                DateTime endDate = StringUtil.stringToDate(endTimer);
                if (endDate.isBefore(startDate)) {
                  // 结束时间不能早于开始时间
                  TTToast.showToast(
                      'End time cannot be earlier than start time');
                  return;
                }
                if (widget.confirm != null) {
                  widget.confirm!(startTime.replaceAll('/', '-'),
                      endTimer.replaceAll('/', '-'), _selectIndex);
                }
                NavigatorUtil.pop();
              },
              child: Container(
                width: 210,
                height: 40,
                decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Constants.regularWhiteTextWidget('Confirm', 14,Colors.white),
                ),
              ),
            ), // Confirm按钮
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}




/*机器人模式提示弹窗*/
class RobotModelAlertDialog extends StatelessWidget {
  Function exchange;

  RobotModelAlertDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),

          SizedBox(
            height: 27,
          ),
          Constants.boldWhiteTextWidget('Training Mode', 20),

          SizedBox(
            height: 45,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/base/train_mode_a.png'),
                width: 153 /2,
                height: 183 /2,
              ),

              SizedBox(
                width: 12,
              ),

              Image(image: AssetImage('images/base/train_mode_b.png'),
                width: 153 /2,
                height: 183 /2,
              ),
            ],

          ),

          SizedBox(
            height: 32,
          ),

          Padding(padding: EdgeInsets.only(left: 34,right: 34),
            child: Text('When Serve&Volley training and the robot will no longer enter the court to pick up the ball',
              textAlign: TextAlign.center,
              // overflow: TextOverflow.visible,
              style: TextStyle(
                color: Constants.connectTextColor,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'SanFranciscoDisplay',
                fontWeight: FontWeight.w400,
              ),
            ) ,
          ),



          SizedBox(
            height: 45,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Confirm',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

class RobotLowBatteryDialog extends StatelessWidget {
  Function exchange;
  String descTitle;
  String title;
  String imgName;


  RobotLowBatteryDialog({required this.exchange,required this.title,required this.descTitle,required this.imgName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: title == 'Bluetooth Disconnected' ? [Container()] : [CancelButton()],
          ),

          SizedBox(
            height: 33,
          ),

          Image(image: AssetImage('${this.imgName}'),
            width: 96 /2,
            height: 83 /2,
          ),

          SizedBox(
            height: 11,
          ),
          Constants.boldWhiteTextWidget('${this.title}', 19),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('${this.descTitle}', 16,Constants.connectTextColor,height: 1.3),

          SizedBox(
            height: 46,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(20),
              title: 'Got It',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

// 扫描连接失败弹窗
class RobotConnectFailedDialog extends StatelessWidget {
  Function exchange;
  String descTitle;
  String title;
  String imgName;


  RobotConnectFailedDialog({required this.exchange,required this.title,required this.descTitle,required this.imgName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Container()],
          ),

          SizedBox(
            height: 33,
          ),

          Image(image: AssetImage('${this.imgName}'),
            width: 37,
            height: 32,
          ),

          SizedBox(
            height: 13,
          ),
          Constants.boldWhiteTextWidget('${this.title}', 19),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('${this.descTitle}', 16,Constants.connectTextColor,height: 1.3),

          SizedBox(
            height: 40,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(20),
              title: 'OK',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}


/*机器人异常弹窗*/
class RobotExceptionDialog extends StatelessWidget {
  Function exchange;
  String title;

  RobotExceptionDialog({required this.exchange,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),

          SizedBox(
            height: 33,
          ),

          Image(image: AssetImage('images/base/exception_icon.png'),
            width: 96 /2,
            height: 83 /2,
          ),

          SizedBox(
            height: 11,
          ),
          Constants.boldWhiteTextWidget('Exception', 20),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('${this.title}', 14,Constants.connectTextColor),

          SizedBox(
            height: 84,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Confirm',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}


//*机器人结束提示弹窗*/
class RobotEndTaskDialog extends StatelessWidget {
  Function exchange;

  RobotEndTaskDialog({required this.exchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [CancelButton()],
          ),
          SizedBox(
            height: 90,
          ),
          Constants.boldWhiteTextWidget('End a Task?', 20),
          SizedBox(
            height: 20,
          ),

          Constants.regularWhiteTextWidget('Whether to end the current mode', 14,Constants.connectTextColor),

          SizedBox(
            height: 84,
          ),
          Padding(padding: EdgeInsets.only(left: 24,right: 24),child: BaseButton(
              borderRadius: BorderRadius.circular(5),
              title: 'Finish',
              height: 40,
              onTap: () {
                this.exchange();
              }),),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
