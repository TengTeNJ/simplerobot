import 'package:flutter/material.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tennis_robot/constant/constants.dart';
import 'package:tennis_robot/robotstats/game_model.dart';
import 'package:tennis_robot/utils/dialog.dart';
import '../models/my_status_model.dart';
import '../utils/color.dart';
import 'my_stats_tip_view.dart';

class MyStatsBarChatView extends StatefulWidget {
  List<MyStatsModel> datas = [];
  double maxLeft;
  int maxCount = 3;

  MyStatsBarChatView({required this.datas, this.maxLeft = 0 ,this.maxCount = 0});
  @override
  State<MyStatsBarChatView> createState() => _MyStatsBarChatViewState();
}

class _MyStatsBarChatViewState extends State<MyStatsBarChatView> {
  late TooltipBehavior _tooltipBehavior;
  bool _disposed = false;
  double _width = 0.3; // 柱状图宽度

  List<String> _titles = [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'Custom'
  ];
  int _timeIndex = 0;
  String _startTime = '';
  String _endTime = '';

  void _callback(Duration duration) {
    if (!_disposed) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateWidthBaseDatas();
    _tooltipBehavior = TooltipBehavior(
      // shouldAlwaysShow: true,
      canShowMarker: false,
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        MyStatsModel model = data as MyStatsModel;
        return MyStatsTipView(dataModel: model);
      },
    );
  }

/*根据数据量计算宽度*/
  calculateWidthBaseDatas() {
    if (widget.datas.length == 1) {
      _width = 0.05;
    } else if (widget.datas.length > 1 && widget.datas.length <= 6) {
      _width = 0.15;
    } else if (widget.datas.length > 6 && widget.datas.length <= 9) {
      _width = 0.2;
    } else if (widget.datas.length > 9 && widget.datas.length <= 13) {
      _width = 0.3;
    } else if (widget.datas.length > 13 && widget.datas.length <= 17) {
      _width = 0.5;
    } else {
      _width = 0.6;
    }
  }

  /*选中柱形图*/
  selectItem(MyStatsModel model) {
    widget.datas.forEach((MyStatsModel number) {
      number.selected = false;
    });
    model.selected = true;
    // 使用 SchedulerBinding.instance.addPostFrameCallback 来延迟调用 setState，以确保在构建完成后再更新状态
    WidgetsBinding.instance.addPersistentFrameCallback(_callback);
  }

  /* 根据日期筛选数据*/
  filterData(String startTime, String endTime) {
    var dateStartTime = DateTime.parse(startTime);
    var dateEndTime = DateTime.parse(endTime);
    List<MyStatsModel> filterData = [];
    widget.datas.forEach((element){
      var currentTime = DateTime.parse(element.gameTimer);
      // 符合筛选条件的数据
      if (currentTime.isAfter(dateStartTime) && dateEndTime.isAfter(currentTime)) {
        filterData.add(element);
      }
    });
    widget.datas = [];
    widget.datas = filterData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
            EdgeInsets.only(left: 16, right: 0 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.mediumBaseTextWidget('Highest ${widget.maxCount}', 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    // 时间选择弹窗
                    TTDialog.timeSelect(context, (startTime, endTime ,index){
                      print('${startTime}--${endTime}--${index}');
                      _timeIndex = index;
                      _startTime = startTime;
                      _endTime = endTime;
                      filterData(startTime, endTime);
                      setState(() {});
                    },index: _timeIndex,start: _startTime != '' ? _startTime :null,end: _endTime != '' ? _endTime : null);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Constants.darkThemeColor,
                      border: Border.all(
                          color: hexStringToColor('#707070'), width: 1),
                    ),
                    padding: EdgeInsets.only(
                        top: 4, bottom: 4, left: 16, right: 16),
                    child: Row(
                      children: [
                        Constants.regularWhiteTextWidget(
                            '${_titles[_timeIndex]}', 14,Colors.white),
                        SizedBox(
                          width: 8,
                        ),
                        Image(
                          image: AssetImage('images/profile/stats_down.png'),
                          width: 8,
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // child: Constants.mediumBaseTextWidget('Highest ${widget.maxCount}', 16),
        ),
        Container(
          height: 120,
          margin: EdgeInsets.only(right: widget.maxLeft + 6,top: 24),
          child: SfCartesianChart(
              margin: EdgeInsets.only(left: 10, right: 0, top: 10),
              plotAreaBorderWidth: 0,
              // 设置绘图区域的边框宽度为0，隐藏边框
              plotAreaBorderColor: Colors.transparent,
              // 设置绘图区域的边框颜色为透明色
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: Color.fromRGBO(156, 156, 156, 1.0),
                  fontSize: 12,
                  fontFamily: 'SanFranciscoDisplay',
                  fontWeight: FontWeight.w500,
                ),
                maximum: 600,
                labelAlignment: LabelAlignment.center,
                interval: 200,
                // X 轴的宽度与颜色  这里设置为透明色，以虚线显示
                axisLine: AxisLine(width: 1, color: Colors.transparent),
                // 设置 X 轴轴线颜色和宽度
                plotOffset: 0,
                labelPosition: ChartDataLabelPosition.outside,
                // labelStyle: TextStyle(fontSize: 12, color: Colors.black), // 设置标签样式
                majorGridLines: MajorGridLines(
                    color: Color.fromRGBO(112, 112, 112, 1.0),
                    dashArray: [2, 2]),
               majorTickLines: MajorTickLines(width: 0),

                //opposedPosition: true, // 将 Y 轴放置在图表的右侧
                // minimum: 0, // 设置 Y 轴的最小值为0
                // maximum: 50, // 设置 Y 轴的最大值
                // interval: 10, // 设置 Y 轴的间隔
                //  edgeLabelPlacement: EdgeLabelPlacement.shift, // 调整标签位置，使得第一个数据和 Y 轴有间隔
              ),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: Colors.transparent,
                  fontSize: 8,
                  fontFamily: 'SanFranciscoDisplay',
                  fontWeight: FontWeight.w400,
                ),
                plotOffset: 1,
                interval: 1,
                axisLine: AxisLine(width: 1, color: Colors.transparent),
                // 设置 X 轴轴线颜色和宽度
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                // 调整标签位置，使得第一个数据和 Y 轴有间隔
                majorGridLines: MajorGridLines(
                    color: Colors.transparent, dashArray: [5, 5]),
                majorTickLines: MajorTickLines(width: 0),
                // minimum: 0, // 设置Y轴的最小值
                // maximum: 10, // 设置Y轴的最大值
              ),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries<MyStatsModel, num>>[
                // Renders column chart
                ColumnSeries<MyStatsModel, num>(
                    selectionBehavior: SelectionBehavior(
                      enable: true, // 这个设置为true,会在选中时，其他的置灰

                      // toggleSelection: false,
                      // overlayMode: ChartSelectionOverlayMode.top, // 设置选中视图显示在柱状图上面
                    ),
                    borderRadius: BorderRadius.circular(5),
                    // 设置柱状图的圆角
                    dataSource: widget.datas,
                    width: _width,
                    // 设置柱状图的宽度，值为 0.0 到 1.0 之间，表示相对于间距的比例
                    spacing: 0.5,
                    //
                    xValueMapper: (MyStatsModel data, _) =>
                        int.parse(data.indexString),
                    yValueMapper: (MyStatsModel data, _) =>
                        data.speed > 50 ? data.speed : data.speed,
                    pointColorMapper: (MyStatsModel data, _) =>
                        hexStringToColor('#F8850B'))
              ]),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }
}
