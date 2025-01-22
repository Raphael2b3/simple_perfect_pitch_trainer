import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/chord_player.dart';

class Solution extends ConsumerStatefulWidget {
  const Solution({super.key});

  @override
  ConsumerState<Solution> createState() =>
      _SolutionState();
}

class _SolutionState extends ConsumerState<Solution> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(chordPlayerProvider, (old, newItem) {
      setState(() {
        revealed = false;
      });
    });
    if (revealed) {
      var chordPlayer = ref.watch(chordPlayerProvider);
      var entries = chordPlayer.value!.entries.toList();
      return Expanded(
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (c, i ) {
            var e = entries[i];
            var player = e.value;
            var note = e.key;
            var isActive = player.state == PlayerState.playing;
            if (isActive) {
              return FilledButton(
                onPressed: () async {
                  await player.stop();
                  setState(() {});
                },
                child: Text("$note Playing"),
              );
            } else {
              return OutlinedButton(
                onPressed: () async {
                  await player.resume();
                  setState(() {});
                },
                child: Text("$note Paused"),
              );
            }
          },

        ),
      );
    } else {
      return FilledButton(
        onPressed: () {
          setState(() {
            revealed = true;
          });
        },
        child: const Text("Reveal Solution"),
      );
    }
  }
}
