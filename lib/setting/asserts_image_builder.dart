import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef AssertsWidgetBuilder = Widget Function(
    BuildContext context, ImageInfo? imageInfo);

class AssertsImageBuilder extends StatefulWidget {
  final ImageProvider imageProvider;
  final AssertsWidgetBuilder builder;

  const AssertsImageBuilder(
      this.imageProvider, {
        super.key,
        required this.builder,
      });

  @override
  State<StatefulWidget> createState() => _AssertsImageBuilderState();
}

class _AssertsImageBuilderState extends State<AssertsImageBuilder> {
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _loadAssertsImage().then((value) {
      setState(() {
        _imageInfo = value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AssertsImageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _loadAssertsImage().then((value) {
        setState(() {
          _imageInfo = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!.call(context, _imageInfo);
  }

  Future<ImageInfo?> _loadAssertsImage() {
    final Completer<ImageInfo?> completer = Completer<ImageInfo?>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ImageConfiguration config = createLocalImageConfiguration(context);
      final ImageStream stream = widget.imageProvider.resolve(config);
      ImageStreamListener? listener;
      listener = ImageStreamListener(
            (ImageInfo? image, bool sync) {
          if (!completer.isCompleted) {
            completer.complete(image);
          }

          SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
            stream.removeListener(listener!);
          });
        },
        onError: (Object exception, StackTrace? stackTrace) {
          stream.removeListener(listener!);
          completer.completeError(exception, stackTrace);
        },
      );
      stream.addListener(listener);
    });

    return completer.future;
  }
}
