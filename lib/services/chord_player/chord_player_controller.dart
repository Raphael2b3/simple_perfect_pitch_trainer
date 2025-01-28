import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

import 'chord_player.dart';

part 'chord_player_controller.g.dart';

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class ChordPlayerController extends _$ChordPlayerController {
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
  FutureOr<ChordPlayer> build() async {
    ref.onDispose(()async {
      await state.value?.dispose();
      throw Exception("Thankfully this is being called");
    });
    var task = await ref.watch(taskGeneratorProvider.future);
    var chordPlayer = await ChordPlayer.create(notesToFilenames(task.notes));
    await resume();
    return chordPlayer;
  }

  List<String> notesToFilenames(List<int> notesToPlay) =>
      notesToPlay.map((i) {
        var name = notes[i % 12];
        var octave = ((i / 12).floor() % 3) + 1;
        return "$name$octave.mp3";
      }).toList();

  Future resume() async {
    for (var player in state.value?.playerList ?? []) {
      await player.resume();
    }
    ref.notifyListeners();
  }

  Future pause() async {
    for (var player in state.value?.playerList ?? []) {
      await player.pause();
    }
    ref.notifyListeners();
  }

}
