import 'package:flutter/material.dart';
import 'package:tennis_robot/startPage/action_bottom_card_view.dart';

class ActionBottomView extends StatefulWidget {
  Function onChange;

  ActionBottomView({required this.onChange});

  @override
  State<ActionBottomView> createState() => _ActionBottomViewState();
}

class _ActionBottomViewState extends State<ActionBottomView> {
  late PageController _pageController;
  int currentPages = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _pageController = PageController(initialPage: 0)
        ..addListener(() {
          int currentpage = _pageController.page!.round();
          currentPages = currentpage;
          setState(() {

          });
          widget.onChange(currentpage);
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(  itemBuilder: (context, index) {
     // SceneModel sceneModel = gameUtil.sceneList[index];
    //  int _index = int.parse(sceneModel.dictKey) - 1;
      return Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
        child: ActionBottomCardView(
          index: currentPages,
        ),
      );
    },
      itemCount: 2,
      controller: _pageController);
  }
}
