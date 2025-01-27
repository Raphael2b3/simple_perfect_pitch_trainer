import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_history.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';

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

  static const List<int> fallbackIntervals = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
  ];

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
  Task? build() {
    return getNewTask();
  }

  List<int> scaleToIntervalList(List<String> scale) {
    return scale.map((e) => intervalList.indexOf(e)).toList();
  }

  List<int>? getRandomSetOfIntervals() {
    var configs = ref.watch(scaleManagerProvider);
    if (!configs.hasValue) {
      return null;
    }
    var actives =
        configs.value!.values.where((value) => value.isActive).toList();
    // get activated scales
    if (actives.isEmpty) {
      return fallbackIntervals;
    }
    var i = random.nextInt(actives.length);
    return scaleToIntervalList(actives[i].values);
  }

  Task getPreviousTask() {
    var pre = taskHistory.getPreviousTask();
    state = pre;
    return pre;
  }

  Task? getNextTask() {
    var task = taskHistory.getNextTask();
    if (task == null) {
      task = getNewTask();
      if (task == null) {
        return null;
      }
      taskHistory.addTask(task);
    }
    state = task;
    return task;
  }

  Task? getNewTask() {
    var numberOfExtraNotes = ref.read(settingsProvider).numberOfExtraNotes;
    var setOfNotes = getRandomSetOfIntervals();
    if (setOfNotes == null) {
      return null;
    }
    int rootNote = random.nextInt(12);
    var notes = [rootNote];
    var maxPossibleNotesPlayed = min(
      1 + numberOfExtraNotes,
      setOfNotes.length * 3,
    );
    while (notes.length < maxPossibleNotesPlayed) {
      var randomNote = setOfNotes[random.nextInt(setOfNotes.length)];
      var randomOctave = random.nextInt(3) * 12;
      var newNote = rootNote + randomOctave + randomNote;
      if (!notes.contains(newNote)) notes.add(newNote);
    }
    var noteNames = notesToName(notes);
    var newTask = Task(notes: notes, solution: noteNames);
    return newTask;
  }

  List<String> notesToName(List<int> notesToPlay) =>
      notesToPlay.map((i) {
        var octave = ((i / 12).floor() % 3) + 1;
        return "${notes[i % 12]}$octave";
      }).toList();
}
