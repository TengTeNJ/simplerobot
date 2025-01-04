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
