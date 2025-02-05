import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

import 'chord_player.dart';

part 'chord_player_controller.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class ChordPlayerController extends _$ChordPlayerController {
  static const List<String> notes = [
    'C',
    'Db',
    'D',
    'Eb',
    'E',
    'F',
    'Gb',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  @override
  FutureOr<ChordPlayer> build() async {
    var task = await ref.watch(taskGeneratorProvider.future);
    ref.listen(
      settingsProvider.select((s) => (s.oneShot, s.autoNext)),
      loopingGate,
    );
    var settings = ref.read(settingsProvider);
    var chordPlayer = await ChordPlayer.create(
      notesToFilenames(task.notes),
      () => ref.notifyListeners(),
      settings.oneShot && !settings.autoNext,
    );
    ref.onDispose(() async {
      await chordPlayer.dispose();
    });
    return chordPlayer;
  }

  Future<void> loopingGate((bool, bool)? old, (bool, bool) news) async {
    var ((oneShot, autoNext), (oldOneShot, oldAutoNext)) = (
      news,
      old ?? (false, false),
    );

    if ((!autoNext && oneShot) && (!oldOneShot || oneShot && oldAutoNext)) {
      await activateOneShot(true);
    }

    if ((oldOneShot && autoNext) || (!autoNext && oldOneShot && !oneShot)) {
      await activateOneShot(false);
    }
  }

  Future<void> activateOneShot(bool oneShot) async {
    var chordPlayer = (await ref.read(chordPlayerControllerProvider.future));
    chordPlayer.oneShot = oneShot;
  }

  Future<void> stopSingleNote(int index) async {
    var chordPlayer = (await ref.read(chordPlayerControllerProvider.future));
    await chordPlayer.playerList[index].stop();
    ref.notifyListeners();
  }

  Future<void> resumeSingleNote(int index) async {
    var chordPlayer = (await ref.read(chordPlayerControllerProvider.future));
    await chordPlayer.playerList[index].resume();
    ref.notifyListeners();
  }

  List<String> notesToFilenames(List<int> notesToPlay) =>
      notesToPlay.map((i) {
        var name = notes[i % 12];
        var octave = ((i / 12).floor() % 3) + 1;
        return "notes/$name$octave.mp3";
      }).toList();

  Future<void> resume() async {
    var chordPlayer = (await ref.read(chordPlayerControllerProvider.future));
    for (var player in chordPlayer.playerList) {
      await player.resume();
    }
    ref.notifyListeners();
  }

  Future<void> pause() async {
    var chordPlayer = (await ref.read(chordPlayerControllerProvider.future));
    for (var player in chordPlayer.playerList) {
      await player.pause();
    }
    ref.notifyListeners();
  }
}
