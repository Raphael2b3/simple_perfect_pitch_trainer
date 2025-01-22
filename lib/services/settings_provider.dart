import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager.dart';

part 'settings_provider.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class SettingsProvider extends _$SettingsProvider {

  @override
  int build() {
    return 1;
  }

  set numberOfExtraNotes(double value) {
    state = value.toInt();
  }
}
