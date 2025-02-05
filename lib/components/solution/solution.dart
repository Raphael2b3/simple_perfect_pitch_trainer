import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/components/reference_note.dart';
import 'package:simple_perfect_pitch_trainer/components/solution/player_list.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';
import 'package:simple_perfect_pitch_trainer/services/ui_state_controller.dart';


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
    var scaleName = task.value?.solution.scaleName;

    Widget child =
        revealed
            ? Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                const ReferenceNote(),
                Text(
                  "Notes From Scale: $scaleName",
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(child: PlayerList()),
              ],
            )
            : Column(
              children: [
                const ReferenceNote(),
                FilledButton(
                  onPressed: () {
                    uiManager.solutionRevealed = true;
                  },
                  child: const Text("Reveal Solution"),
                ),
                if (expanded)
                  Expanded(
                    child: Center(
                      child: Text(
                        "Press Play.\nWhat Notes Do You Hear?\nWhat Intervals Do You Hear?",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );

    if (expanded || revealed) child = Expanded(child: child);

    return child;
  }
}
