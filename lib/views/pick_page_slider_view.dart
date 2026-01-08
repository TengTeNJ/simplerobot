import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../constant/constants.dart';
import '../setting/asserts_image_builder.dart';
import '../setting/image_slider_thumb.dart';


/// 滑竿view
class PickPageSliderView extends StatefulWidget {
  double defaultValue;
  Function? chooseValue;

  PickPageSliderView({this.chooseValue,required this.defaultValue});

  @override
  State<PickPageSliderView> createState() => _SliderViewState();

}

class _SliderViewState extends State<PickPageSliderView> {
  late ImageProvider imageProvider = AssetImage('images/base/slider_new_shape.png');

  double _sliderValue = 2.0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _sliderValue = widget.defaultValue;
    //_sliderValue = defaultValue;
    print('默认值${_sliderValue}');
    print('默认值222${widget.defaultValue}');

  }

  @override
  Widget buildSliderWidget() {
    return Slider(
      //Slider的当前的值
      value: _sliderValue,
      min: 1,
      max: 3,
      //平均分成的等分
      divisions: 2,
      //滚动时会回调
      onChanged: (double value) {
        Vibration.vibrate(duration: 500); // 触发震动
        _sliderValue = value;
        setState(() {});
      },
      onChangeStart: (double startValue) {
        print("开始滚动${startValue}");
      },
      onChangeEnd: (double endValue) {
        print("停止 滚动${endValue}");
        print('8888${widget.defaultValue}');


        if (widget.chooseValue != null) {
          widget.chooseValue!(endValue);
        }
      },
      //气泡
      label: "${widget.defaultValue.toStringAsFixed(1)}",
    );
  }

  Widget buildThem() {
    return AssertsImageBuilder(imageProvider, builder: (context ,imageInfo){
      return Theme(
        data: ThemeData(
            sliderTheme: SliderThemeData(
              trackHeight: 16,
              //滑块的颜色
              //thumbColor: Colors.deepOrange,
              thumbColor: Constants.selectedModelBgColor,
              //滑块的大小
              //  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18),
              thumbShape: ImageSliderThumb(image: imageInfo?.image,size: Size(30, 30)),
              //点击滑块边缘的颜色
              // overlayColor: Colors.deepPurpleAccent.withOpacity(0.2),
              // overlayColor: Colors.white,
              //点击滑块边缘的显示半径
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
              //滑动左侧滚动条的颜色
              activeTrackColor:  Constants.connectTextColor,
              //滚动条右侧的颜色
              inactiveTrackColor:Constants.connectTextColor,
              //任何情况都显示气泡
              showValueIndicator: ShowValueIndicator.never,
              // 活跃的分段点的颜色
              activeTickMarkColor: Constants.connectTextColor,
              // 不活跃的分段点的颜色
              inactiveTickMarkColor: Constants.connectTextColor,

            )
        ),
        child: buildSliderWidget(),
      );
    }
    );
  }

  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) -88 ,
      height: 30,
      child: buildThem(),
    );
  }


}
