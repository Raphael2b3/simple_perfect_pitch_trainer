import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager.dart';

part 'solution_state.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class SolutionState extends _$SolutionState {

  @override
  bool build() {
    return false;
  }

  set revealed(bool v) => state = v;

}
