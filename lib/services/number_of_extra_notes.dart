import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager.dart';

part 'number_of_extra_notes.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class NumberOfExtraNotes extends _$NumberOfExtraNotes {

  @override
  double build() {
    return 1;
  }

  set numberOfExtraNotes(double value) => state = value;

}
