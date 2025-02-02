import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/components/solution/player_list.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';
import 'package:simple_perfect_pitch_trainer/services/ui_state_controller.dart';

import '../../services/chord_player/chord_player_controller.dart';

class Solution extends ConsumerWidget {
  const Solution({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var uiManager = ref.read(uiStateControllerProvider.notifier);
    var revealed = ref.watch(
      uiStateControllerProvider.select((v) => v.solutionRevealed),
    );
    var expanded = ref.watch(
      uiStateControllerProvider.select((v) => v.solutionExpanded),
    );

    var task = ref.watch(taskGeneratorProvider);

    var child =
        revealed
            ? Column(
              children: [
                Text("Solution", style: TextStyle(fontSize: 20)),
                Expanded(child: PlayerList()),
              ],
            )
            : Center(
              child: FilledButton(
                onPressed: () {
                  uiManager.solutionRevealed = true;
                },
                child: const Text("Reveal Solution"),
              ),
            );
    if (expanded || revealed) return Expanded(child: child);
    return child;
  }
}
