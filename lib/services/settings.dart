
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings.g.dart';

class SettingsData{
  double numberOfExtraNotes = 0;
  bool oneShot = true;
  bool callSolution = false;
  bool autoNext = false;
  int skipTimeOut = 6;
}
// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class Settings extends _$Settings {
  set numberOfExtraNotes(double numberOfExtraNotes) {
    state.numberOfExtraNotes = numberOfExtraNotes;
    ref.notifyListeners();
  }

  set skipTimeOut(int v) {
    state.skipTimeOut = v;

    ref.notifyListeners();
  }
  set oneShot(bool v) {
    state.oneShot = v;
    ref.notifyListeners();
  }
  set autoNext(bool v) {
    state.autoNext = v;
    ref.notifyListeners();
  }

  set callSolution(bool v) {
    state.callSolution = v;
    ref.notifyListeners();
  }

  @override
  SettingsData build() {
    return SettingsData();
  }

}
