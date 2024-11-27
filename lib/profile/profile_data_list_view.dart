import 'package:flutter/material.dart';
import 'package:tennis_robot/profile/profile_list_view.dart';

class ProfileDataListView extends StatefulWidget {
  const ProfileDataListView({super.key});

  @override
  State<ProfileDataListView> createState() => _ProfileDataListViewState();
}

class _ProfileDataListViewState extends State<ProfileDataListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(width: 16,),
            ProfileListView(assetPath: 'images/profile/setting_profile.png', title: 'Profile',),
            // SizedBox(width: 7,),
              ProfileListView(assetPath: 'images/profile/setting_ball_type.png',title: 'Ball Type'),
            SizedBox(width: 16,)
            ]
        ),
        SizedBox(height: 8,),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 16,),
              ProfileListView(assetPath: 'images/profile/setting_fault.png', title: 'Fault',),
              // SizedBox(width: 10,),
              ProfileListView(assetPath: 'images/profile/setting_roller_speed.png',title: 'Roller Speed'),
              SizedBox(width: 16,)
            ]
        ),
        SizedBox(height: 8,),

        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 25,),
              ProfileListView(assetPath: 'images/profile/setting_distance.png', title: 'Safe Distance',),
            ]
        ),
      ],

    );
  }
}
