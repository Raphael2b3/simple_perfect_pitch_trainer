import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';

part 'ui_state_controller.g.dart';

class UIState{

}
// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class UIStateController extends _$UIStateController {

  @override
  UIState build() {
    return UIState();
  }

}
