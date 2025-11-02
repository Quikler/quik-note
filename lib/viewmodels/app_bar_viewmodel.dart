import 'package:flutter/foundation.dart';
enum AppBarMode {
  initial,
  select,
}
class AppBarViewModel extends ChangeNotifier {
  AppBarMode _mode = AppBarMode.initial;
  AppBarMode get mode => _mode;
  bool get isSelectMode => _mode == AppBarMode.select;
  bool get isInitialMode => _mode == AppBarMode.initial;
  void setMode(AppBarMode newMode) {
    if (_mode != newMode) {
      _mode = newMode;
      notifyListeners();
    }
  }
  void enterSelectMode() {
    setMode(AppBarMode.select);
  }
  void exitSelectMode() {
    setMode(AppBarMode.initial);
    notifyListeners();
  }
  void toggleMode() {
    setMode(
      _mode == AppBarMode.initial ? AppBarMode.select : AppBarMode.initial,
    );
  }
  @override
  void dispose() {
    _mode = AppBarMode.initial;
    super.dispose();
  }
}
