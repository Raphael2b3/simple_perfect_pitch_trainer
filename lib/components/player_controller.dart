import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player.dart';
import 'package:simple_perfect_pitch_trainer/services/number_of_extra_notes.dart';
import 'package:simple_perfect_pitch_trainer/services/solution_state.dart';

class PlayerController extends ConsumerWidget {
  const PlayerController({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chordPlayerProvider);
    var player = ref.read(chordPlayerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed:
              () async =>
                  await ref.read(chordPlayerProvider.notifier).previous(),
          child: const Text("Previous"),
        ),
        if (player.isPlaying)
          OutlinedButton(
            onPressed:
                () async =>
                    await ref.read(chordPlayerProvider.notifier).pause(),
            child: const Text("Pause"),
          )
        else
          FilledButton(
            onPressed:
                () async =>
                    await ref.read(chordPlayerProvider.notifier).resume(),
            child: const Text("Play"),
          ),
        TextButton(
          onPressed: () async {
            await ref
                .read(chordPlayerProvider.notifier)
                .forward();
            ref.read(solutionStateProvider.notifier).revealed = false;
          },
          child: const Text("Next"),
        ),
      ],
    );
  }
}
