import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

import 'chord_player/chord_player_controller.dart';

part 'auto_skip_timer.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class AutoSkipTimer extends _$AutoSkipTimer {
  Timer? timer;

  @override
  Timer? build() {
    print("Building Timer");
    var (autoSkip, skipTimeOut) = ref.watch(
      settingsProvider.select((e) => (e.autoNext, e.skipTimeOut)),
    );
    if (!autoSkip) return null;

    print("AutoSkipTimer: $skipTimeOut");
    var timer =  Timer.periodic(Duration(seconds: skipTimeOut), (t) async {
      await ref.read(taskGeneratorProvider.notifier).getNextTask();
      await ref.read(chordPlayerControllerProvider.notifier).resume();
    });

    ref.onDispose(() {
      timer.cancel();
    });
    return timer;

  }
}
