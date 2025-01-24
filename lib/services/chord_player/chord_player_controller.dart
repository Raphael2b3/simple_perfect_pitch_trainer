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
  FutureOr<ChordPlayer?> build() async {
    ref.onDispose(() async => await state.value?.dispose());
    return null;
  }

  List<String> notesToFilenames(List<int> notesToPlay) =>
      notesToPlay.map((i) {
        var name = notes[i % 12];
        var octave = ((i / 12).floor() % 3) + 1;
        return "$name$octave.mp3";
      }).toList();

  Future updatePlayers(Task task) async {
    await state.value?.dispose();
    state = await AsyncValue.guard(
      () async => await ChordPlayer.create(notesToFilenames(task.notes)),
    );
    await resume();

  }

  Future resume() async {
    for (var player in state.value!.playerList) {
      await player.resume();
    }
    ref.notifyListeners();
  }

  Future pause() async {
    for (var player in state.value!.playerList) {
      await player.pause();
    }
    ref.notifyListeners();
  }

  Future previous() async {
    var task = ref.read(taskGeneratorProvider.notifier).getPreviousTask();
    await updatePlayers(task);
  }

  Future forward() async {
    var task = ref.read(taskGeneratorProvider.notifier).getNextTask();
    await updatePlayers(task);
  }

  Future dispose() async {
    for (var player in state.value!.values) {
      await player.dispose();
    }
    state.value!.clear();
  }
}
