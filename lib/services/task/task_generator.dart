import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/solution.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_history.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';

part "task_generator.g.dart";

@Riverpod(keepAlive: true)
class TaskGenerator extends _$TaskGenerator {
  static Random random = Random();
  static const List<String> intervalList = [
    "1",
    "b2",
    "2",
    "b3",
    "3",
    "4",
    "b5",
    "5",
    "b6",
    "6",
    "7",
    "j7",
  ];

  TaskHistory taskHistory = TaskHistory();

  static ScaleConfig fallbackConfig = ScaleConfig(
    name: "Fallback",
    values: ["1", "2", "3", "4", "5", "6", "j7"],
    isActive: true,
    isCustom: false,
  );

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

  get scaleManager => ref.read(scaleManagerProvider.notifier);

  @override
  Future<Task> build() async {
    return await getNewTask();
  }

  List<int> scaleToIntervalList(List<String> scale) {
    return scale.map((e) => intervalList.indexOf(e)).toList();
  }

  Future<ScaleConfig> getRandomScale() async {
    var configs = await ref.read(scaleManagerProvider.future);
    List<ScaleConfig> actives =
        configs.values.where((value) => value.isActive).toList();
    // get activated scales
    if (actives.isEmpty) {
      return fallbackConfig;
    }
    var i = random.nextInt(actives.length);
    return actives[i];
  }

  void getPreviousTask() =>
      state = AsyncValue.data(taskHistory.getPreviousTask());

  Future<void> getNextTask() async =>
      state = AsyncValue.data(taskHistory.getNextTask() ?? await getNewTask());

  Future<Task> getNewTask() async {
    var numberOfExtraNotes = ref.read(settingsProvider).numberOfExtraNotes;
    var scale = await getRandomScale();
    var setOfNotes = scaleToIntervalList(scale.values);
    int rootNote = random.nextInt(12);
    var notes = [rootNote];
    var maxPossibleNotesPlayed = min(
      1 + numberOfExtraNotes,
      setOfNotes.length * 2 + 1,
    );
    List<String> usedIntervals = [];

    while (notes.length < maxPossibleNotesPlayed) {
      int randomNote = setOfNotes[random.nextInt(setOfNotes.length)];
      int randomOctave = 12 + random.nextInt(2) * 12;
      int newNote = rootNote + randomOctave + randomNote;
      usedIntervals.add(intervalList[randomNote]);
      if (!notes.contains(newNote)) notes.add(newNote);
    }
    var noteNames = notesToName(notes);
    var solution = Solution(
      noteNames: noteNames,
      intervals: usedIntervals,
      scaleName: scale.name,
      rootNote: noteNames[0],
      noteIds: notes,
    );
    var newTask = Task(notes: notes, solution: solution);
    taskHistory.addTask(newTask);
    return newTask;
  }

  List<String> notesToName(List<int> notesToPlay) =>
      notesToPlay.map((i) {
        var octave = ((i / 12).floor() % 3) + 1;
        return "${notes[i % 12]}$octave";
      }).toList();
}
