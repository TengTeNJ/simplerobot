import 'package:flutter/material.dart';

import '../constant/constants.dart';


class EmptyView extends StatelessWidget {
  String title;
  EmptyView({this.title = 'No data yet.'});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Constants.mediumBaseTextWidget('12', 16),
      ),
    );
  }
}
