import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager.dart';

part 'chord_player.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class ChordPlayer extends _$ChordPlayer {
  static const List<String> notes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  @override
  FutureOr<Map<String, AudioPlayer>> build() async {
    ref.keepAlive();
    Map<String, AudioPlayer> players = {};
    return players;
  }

  get isPlaying =>
      state.value?.values.any(
        (player) => player.state == PlayerState.playing,
      ) ??
      false;

  List<String> notesToFilename(List<int> notes) =>
      notes.map((i) {
        var name = notes[i % 12];
        var octave = ((i / 12).floor() % 3) + 1;
        return "$name$octave.mp3";
      }).toList();

  Future updatePlayers(List<int> notes) async {
    await dispose();
    var filenames = notesToFilename(notes);

    Map<String, AudioPlayer> newPlayers = {};
    for (var filename in filenames) {
      var newPlayer = AudioPlayer();
      await newPlayer.setPlayerMode(PlayerMode.lowLatency);
      await newPlayer.setSourceAsset(filename);
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      newPlayers[filename.replaceFirst(".mp3", "")] = newPlayer;
    }
    await resume();
    state = AsyncValue.data(newPlayers);
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

  Future previous() async {
    var scaleManager = ref.read(scaleManagerProvider.notifier);
    var notes = scaleManager.getPreviousNotes();
    await updatePlayers(notes);
  }

  Future forward(int numberOfExtraNotes) async {
    var scaleManager = ref.read(scaleManagerProvider.notifier);
    var notes = scaleManager.getNextNotes(numberOfExtraNotes);
    await updatePlayers(notes);
  }

  Future dispose() async {
    for (var player in state.value!.values) {
      await player.dispose();
    }
    state.value!.clear();
  }
}
