import './model.dart';
import './api/index.dart' as api;
import './bridge.dart';

export './page.dart';
export './model.dart';

injectApi(Function(String id, CallModel model) fn) {
  api.inject(fn);
}

setExitRoute(String route) {
  MiniBridge.exitRoute = route;
}