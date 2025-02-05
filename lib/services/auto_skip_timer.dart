import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/solution_player/solution_player.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

import 'chord_player/chord_player_controller.dart';

part 'auto_skip_timer.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class AutoSkipTimer extends _$AutoSkipTimer {

  @override
  Timer? build() {
    var (autoSkip, skipTimeOut) = ref.watch(
      settingsProvider.select((e) => (e.autoNext, e.skipTimeOut)),
    );
    if (!autoSkip) return null;
    ref.watch(taskGeneratorProvider);

    var timer = Timer(Duration(seconds: skipTimeOut), () async {

      if (ref.read(settingsProvider).callSolution) {
        await ref.read(chordPlayerControllerProvider.notifier).pause();
        var task = await ref.read(taskGeneratorProvider.future);
        await playSolution(task.solution, true, true);
      }
      await ref.read(taskGeneratorProvider.notifier).getNextTask();

    });

    ref.onDispose(() {
      timer.cancel();
    });
    return timer;
  }
}
