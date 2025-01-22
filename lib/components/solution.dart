import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/solution_state.dart';

import '../services/chord_player.dart';

class Solution extends ConsumerWidget {
  const Solution({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var revealed = ref.watch(solutionStateProvider);
    var revealedManager = ref.read(solutionStateProvider.notifier);
    var chordPlayer = ref.watch(chordPlayerProvider);
    if (revealed) {
      var entries = chordPlayer.value!.entries.toList();
      return Expanded(
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (c, i) {
            var e = entries[i];
            var player = e.value;
            var note = e.key;
            var isActive = player.state == PlayerState.playing;
            if (isActive) {
              return FilledButton(
                onPressed: () async {
                  var chordPlayerManager = ref.read(chordPlayerProvider.notifier);
                  await player.pause();
                  chordPlayerManager.notifyListeners();
                },
                child: Text("$note Playing"),
              );
            } else {
              return OutlinedButton(
                onPressed: () async {
                  var chordPlayerManager = ref.read(
                    chordPlayerProvider.notifier,
                  );
                  await player.resume();
                  chordPlayerManager.notifyListeners();
                },
                child: Text("$note Paused"),
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
              revealedManager.revealed = true;
            },
            child: const Text("Reveal Solution"),
          ),
        ),
      );
    }
  }
}
