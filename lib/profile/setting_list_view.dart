import 'package:flutter/material.dart';
import 'package:tennis_robot/models/setting_model.dart';
import 'package:tennis_robot/profile/setting_item_view.dart';

class SettingListView extends StatefulWidget {
  List<SettingModel> datas;

  SettingListView({required this.datas});

  @override
  State<SettingListView> createState() => _SettingListViewState();
}

class _SettingListViewState extends State<SettingListView> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context ,index){
       return SettingItemView(model: widget.datas[index],);
    }, separatorBuilder: (context ,index) => SizedBox(
      height: 10,
    ), itemCount: widget.datas.length);
  }
}
