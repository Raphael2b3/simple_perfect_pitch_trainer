import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/chord_generator.dart';

part 'chord_player.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class ChordPlayer extends _$ChordPlayer {
  @override
  FutureOr<Map<String, AudioPlayer>> build() async {
    ref.keepAlive();
    Map<String, AudioPlayer> players = {};
    return players;
  }


  List<List<String>> history = [];

  List<String> getScale() {
    var generator = ref.read(chordGeneratorProvider.notifier);
    var scale = generator.getNewNotes();

    return scale;
  }

  Future updatePlayers(List<String> scale) async {
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

  Future loadNewPlayer() async {
    await dispose();
    var scale = getScale();
    await updatePlayers(scale);
    history.add(scale);
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
