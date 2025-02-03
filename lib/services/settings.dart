import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player/chord_player_controller.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';

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
