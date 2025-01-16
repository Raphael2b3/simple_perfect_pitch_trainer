import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chord_player.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class ChordPlayer extends _$ChordPlayer {
  @override
  FutureOr<Map<String, AudioPlayer>> build() async {
    Map<String, AudioPlayer> players = {};
    return players;
  }

  Future loadNewPlayer(List<String> scale) async {
    await dispose();
    Map<String, AudioPlayer> newPlayers = {};
    for (var note in scale) {
      var newPlayer = AudioPlayer();
      await newPlayer.setPlayerMode(PlayerMode.lowLatency);
      await newPlayer.setSourceAsset("$note.mp3");
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      newPlayers[note] = newPlayer;
    }
    state = await AsyncValue.guard(() async {
      return newPlayers;
    });
  }

  Future resume() async {
    for (var player in state.value!.values) {
      await player.resume();
    }
  }

  Future pause() async {
    for (var player in state.value!.values) {
      await player.pause();
    }
  }

  Future dispose() async {
    for (var player in state.value!.values) {
      await player.dispose();
    }
    state.value!.clear();
  }
}

class ChordController extends ConsumerStatefulWidget {
  const ChordController({super.key});

  @override
  ConsumerState<ChordController> createState() => _ChordControllerState();
}

class _ChordControllerState extends ConsumerState<ChordController> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    var chordPlayer = ref.watch(chordPlayerProvider);
    ref.listen(chordPlayerProvider, (old,newItem) {setState(() {
      revealed = false;
    }); } );
    if (revealed) {
      return Expanded(
        child: ListView(
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
        ),
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
