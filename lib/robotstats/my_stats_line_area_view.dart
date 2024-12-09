import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tennis_robot/models/pickupBall_time.dart';
import '../constant/constants.dart';
import 'empty_view.dart';

class MyStatsLineAreaView extends StatefulWidget {
  MyStatsLineAreaView({required this.datas ,required this.aveDatas, required this.maxCount});
  List<PickupballTime> datas = []; // 个人训练的数据
  List<PickupballTime> aveDatas = []; // 平均时间的数据
  int maxCount = 3;

  @override
  State<MyStatsLineAreaView> createState() => _MyStatsLineAreaViewState();
}
// 折线图（个人训练时长  平均训练时长数据）
class _MyStatsLineAreaViewState extends State<MyStatsLineAreaView> {
  @override
  Widget build(BuildContext context) {
    return widget.datas.length > 0
        ? SfCartesianChart(
      title: ChartTitle(
          text: '  ',
          alignment: ChartAlignment.near,
          textStyle:
          TextStyle(color: Color.fromRGBO(233, 100, 21, 1.0), fontWeight: FontWeight.w500)),
      // backgroundColor: Colors.red,
      margin: EdgeInsets.only(left: 10, right: 20, top: 0),
      // legend: Legend(isVisible: true),
      selectionType: SelectionType.point,
      plotAreaBorderColor: Colors.transparent,
      // 控制和Y交叉方向的直线的样式
      primaryYAxis: NumericAxis(
          labelFormat: '{value}h',
          // https://help.syncfusion.com/flutter/cartesian-charts/axis-customization(图表官方文档)
          // labelFormat: (value) => '${value}h',
          edgeLabelPlacement: EdgeLabelPlacement.none,
          // 移除左侧的填充
          labelStyle: TextStyle(
            color: Color.fromRGBO(156, 156, 156, 1.0),
            fontSize: 12,
            fontFamily: 'SanFranciscoDisplay',
            fontWeight: FontWeight.w500,
          ),
          maximum: 3.0,
          axisLine: AxisLine(width: 2, color: Colors.transparent),
          // 设置 X 轴轴线颜色和宽度
          labelPosition: ChartDataLabelPosition.outside,
          plotOffset: 0,
          interval: 1.0,
          majorTickLines: MajorTickLines(color: Colors.transparent, size: 0),
          // 超出坐标系部分的线条设置
          majorGridLines: MajorGridLines(
              color: Color.fromRGBO(112, 112, 112, 1.0),
              dashArray: [2, 2]),
        // 设置Y轴网格竖线为虚线,

      ),
      // backgroundColor: Color.fromRGBO(41, 41, 54, 1.0),
      onSelectionChanged: (SelectionArgs args) {
        //selectedIndexes.clear(); // 清空之前选中的索引
      },
      // X 横坐标的数字（设置成透明色，不限时）
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          color: Colors.transparent,
          fontSize: 14,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
        ),
        axisLine:
        // X 轴的宽度与颜色  这里设置为透明色，以虚线显示
        AxisLine(width: 1, color: Colors.transparent),
        // 设置 X 轴轴线颜色和宽度
        labelPosition: ChartDataLabelPosition.inside,
        // interval: 2,
        majorGridLines:
        MajorGridLines(color: Colors.transparent, dashArray: [2, 2]),
        majorTickLines:
        MajorTickLines(color: Colors.white, size: 0), // 超出坐标系部分的线条设置
      ),
      // tooltipBehavior: _tooltipBehavior,
      series: <CartesianSeries<PickupballTime, String>>[
        AreaSeries(

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent
              ],
            ),
            // color: Colors.green,
            borderColor: Constants.baseStyleColor,
            // 设置边界线颜色
            borderWidth: 1,
            // 设置边界线宽度
            // 这里是选中的折线的颜色
            // 这里是选中的折线的颜色
            markerSettings: MarkerSettings(
              isVisible: true,
              borderColor: Color.fromRGBO(248, 98, 21, 1),
              shape: DataMarkerType.circle,
              // 设置数据点为圆形
              color: Constants.baseStyleColor,
              // 设置数据点颜色
              height: 1,
              // 设置数据点高度
              width: 1, // 设置数据点宽度
            ),


            dataSource: widget.datas,
            pointColorMapper: (PickupballTime data, _) => Color.fromRGBO(233,100,21,1.0),
            xValueMapper: (PickupballTime data, _) => data.time,
            yValueMapper: (PickupballTime data, _) => double.parse(data.pickupBallTime)),
        AreaSeries(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent
              ],
            ),
            borderColor: Color.fromRGBO(26, 205, 123, 1.0),
            // 设置边界线颜色
            borderWidth: 1,

            dataSource: widget.aveDatas,
            pointColorMapper: (PickupballTime data, _) => Color.fromRGBO(26,205,123,1.0),
            xValueMapper: (PickupballTime data, _) => data.time,
            yValueMapper: (PickupballTime data, _) => double.parse(data.pickupBallTime)),

      ],
    )
        : EmptyView(title: 'There is no data for today.',);
  }
}
