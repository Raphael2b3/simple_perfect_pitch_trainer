import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player/chord_player_controller.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

class PlayerList extends ConsumerWidget {
  const PlayerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var task = ref.watch(taskGeneratorProvider);
    if (!task.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: task.value!.solution.noteNames.length,
      itemBuilder: (c, i) {
        var solutionName = task.value!.solution.noteNames[i];
        var isPlaying = ref.watch(
          chordPlayerControllerProvider.select((v) {
            return v.value?.playerList[i].state == PlayerState.playing;
          }),
        );
        if (isPlaying) {
          return FilledButton(
            onPressed: () async {
              await ref
                  .read(chordPlayerControllerProvider.notifier)
                  .stopSingleNote(i);
            },
            child: Text("$solutionName Playing"),
          );
        } else {
          return OutlinedButton(
            onPressed: () async {
              await ref
                  .read(chordPlayerControllerProvider.notifier)
                  .resumeSingleNote(i);
            },
            child: Text("$solutionName Paused"),
          );
        }
      },
    );
  }
}
