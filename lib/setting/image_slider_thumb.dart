import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageSliderThumb extends SliderComponentShape {
  final Size size;
  final ui.Image? image;

  const ImageSliderThumb({
    required this.image,
    Size? size
  }): size = size ?? const Size(42, 42);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return size;
  }

  @override
  void paint(PaintingContext context, Offset center, {required Animation<double> activationAnimation, required Animation<double> enableAnimation, required bool isDiscrete, required TextPainter labelPainter, required RenderBox parentBox, required SliderThemeData sliderTheme, required TextDirection textDirection, required double value, required double textScaleFactor, required Size sizeWithOverflow}) {
    //图片中心点
    double dx = size.width/2;
    double dy = size.height/2;

    if(image != null) {
      final Rect sourceRect = Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.width.toDouble());
      //center会随着滑块的移动而改变，所以这里需要根据center计算图片绘制的位置
      double left = center.dx - dx;
      double top = center.dy - dy;
      double right = center.dx + dx;
      double bottom = center.dy + dy;
      Rect destinationRect = Rect.fromLTRB(left, top, right, bottom);

      final Canvas canvas = context.canvas;
      final Paint paint = new Paint();
      paint.isAntiAlias = true;
      //绘制滑块
      canvas.drawImageRect(image!, sourceRect, destinationRect, paint);
    }
  }
}
