import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chord_player.dart';

class ChordPlayerController extends ConsumerStatefulWidget {
  const ChordPlayerController({super.key});

  @override
  ConsumerState<ChordPlayerController> createState() =>
      _ChordPlayerControllerState();
}

class _ChordPlayerControllerState extends ConsumerState<ChordPlayerController> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    var chordPlayer = ref.watch(chordPlayerProvider);
    ref.listen(chordPlayerProvider, (old, newItem) {
      setState(() {
        revealed = false;
      });
    });
    if (revealed) {
      return ListView(
        children: [
          ...chordPlayer.value!.entries.map((e) {
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
          }),
        ],
      );
    } else {
      return FilledButton(
        onPressed: () {
          setState(() {
            revealed = true;
          });
        },
        child: Text("Reveal Solution"),
      );
    }
  }
}
