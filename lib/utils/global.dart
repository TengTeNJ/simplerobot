import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';

class GameUtil {
  int currentPage = 0;
  bool nowISGamePage = false; // 是否在游戏页面，如果不在，收到了蓝牙的响应数据则不处理
  int pageDepth = 0; // 页面深度
  bool selectRecord = false;
  int masterStatu = 0; //  主机的状态
  bool gameLocking = false; //  游戏保护期
  BleStatus bleStatus = BleStatus.unknown; // 蓝牙的状态
  bool isBLEListPage = false; // 当前是否在蓝牙列表页
}

/*
* 游戏保护/解除游戏保护
* */
lockGame(bool lock) {
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  gameUtil.gameLocking = lock;
}

/*获取游戏保护期状态*/
bool getGameLockStatu() {
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  return gameUtil.gameLocking;
}


/// 显示 Loading，并在 [timeout] 后自动关闭（如果还在显示）
Timer? _loadingTimer;

void showLoadingWithTimeout({
  String status = 'loading...',
  EasyLoadingMaskType maskType = EasyLoadingMaskType.clear,
  Duration timeout = const Duration(seconds: 15),
}) {
  EasyLoading.show(status: status, maskType: maskType);

  // 先清掉上一轮定时器，防止重复
  _loadingTimer?.cancel();
  _loadingTimer = Timer(timeout, () {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
      // 可选：提示用户
      EasyLoading.showError('连接超时，请检查设备');
    }
  });
}
/// 手动关闭（请求成功/失败时调用）
void hideLoading() {
  _loadingTimer?.cancel();
  if (EasyLoading.isShow) EasyLoading.dismiss();
}
