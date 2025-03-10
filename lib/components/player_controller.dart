import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player/chord_player_controller.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

class PlayerController extends ConsumerWidget {
  const PlayerController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isPlaying = ref.watch(
      chordPlayerControllerProvider.select((e) => e.value?.isPlaying ?? false),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () async {
            ref.read(taskGeneratorProvider.notifier).getPreviousTask();
          },
          child: const Text("Previous"),
        ),
        if (isPlaying)
          OutlinedButton(
            onPressed: () async {
              await ref.read(chordPlayerControllerProvider.notifier).pause();
              ref.read(settingsProvider.notifier).autoNext = false;
            },
            child: const Text("Pause"),
          )
        else
          FilledButton(
            onPressed:
                () async =>
                    await ref
                        .read(chordPlayerControllerProvider.notifier)
                        .resume(),
            child: const Text("Play"),
          ),
        TextButton(
          onPressed: () async {
            await ref.read(taskGeneratorProvider.notifier).getNextTask();
          },
          child: const Text("Next Task"),
        ),
      ],
    );
  }
}
