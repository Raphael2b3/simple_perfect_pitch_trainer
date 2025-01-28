import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';
import 'package:simple_perfect_pitch_trainer/services/ui_state_controller.dart';

import '../services/chord_player/chord_player_controller.dart';

class Solution extends ConsumerWidget {
  const Solution({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var task = ref.watch(taskGeneratorProvider);
    var uiManager = ref.read(uiStateControllerProvider.notifier);
    var revealed = ref.watch(uiStateControllerProvider.select((v)=>v.solutionRevealed));
    if (!task.hasValue) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (revealed) {
      return Expanded(
        child: ListView.builder(
          itemCount: task.value!.solution.length,
          itemBuilder: (c, i) {
            var solutionName = task.value!.solution[i];
            var isPlaying = ref.watch(
              chordPlayerControllerProvider.select((v) {
                return v.value?.playerList[i].state == PlayerState.playing;
              }),
            );

            if (isPlaying) {
              return FilledButton(
                onPressed: () async {},
                child: Text("$solutionName Playing"),
              );
            } else {
              return OutlinedButton(
                onPressed: () async {},
                child: Text("$solutionName Paused"),
              );
            }
          },
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: FilledButton(
            onPressed: () {
              uiManager.updateUIState(UIState(solutionRevealed: true));
            },
            child: const Text("Reveal Solution"),
          ),
        ),
      );
    }
  }
}
