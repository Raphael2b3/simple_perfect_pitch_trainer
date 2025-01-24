import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_history.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';


part "task_generator.g.dart";

@riverpod
class TaskGenerator extends _$TaskGenerator {
  static Random random = Random();
  ScaleStorage scaleStorage = ScaleStorage();
  ScaleHistory scaleHistory = ScaleHistory();
  int numberOfExtraNotes = 1;

  static const Map<String, List<String>> defaultConfigs = {
    'Chromatic': [
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
    ],
    'Ionian': ["1", "2", "3", "4", "5", "6", "j7"],
    'Dorian': ["1", "2", "b3", "4", "5", "6", "b7"],
    'Phrygian': ["1", "b2", "b3", "4", "5", "b6", "b7"],
    'Lydian': ["1", "2", "3", "b5", "5", "6", "j7"],
    'Mixolydian': ["1", "2", "3", "4", "5", "6", "b7"],
    'Aeolian': ["1", "2", "b3", "4", "5", "b6", "b7"],
    'Locrian': ["1", "b2", "b3", "4", "b5", "b6", "b7"],
    "Major Pentatonic": ["1", "2", "3", "5", "6"],
    "Minor Pentatonic": ["1", "b3", "4", "5", "b7"],
    "Blues": ["1", "b3", "4", "b5", "5", "b7"],
    "Whole Tone": ["1", "2", "3", "b5", "b6", "b7"],
    "Augmented": ["1", "b3", "3", "5", "b6", "b7"],
    "Diminished": ["1", "b2", "b3", "3", "b5", "5", "b6", "6", "b7", "7"],
    "Melodic Minor": ["1", "2", "b3", "4", "5", "6", "j7"],
    "Harmonic Minor": ["1", "2", "b3", "4", "5", "b6", "j7"],
  };
  static const List<int> fallbackIntervals = [0];

  get activeConfigs => scaleStorage.activeConfigs;
  get customConfigs => scaleStorage.customConfigs;

  @override
  Future build() async {
    await scaleStorage.init();
    // load active states that are not stored initially or when app data is cleared
    for (var key in [...defaultConfigs.keys, ...customConfigs.keys]) {
      if (!activeConfigs.containsKey(key)) {
        activeConfigs[key] = false;
      }
    }
  }

  List<String> scaleByName(String name) {
    return defaultConfigs[name] ?? customConfigs[name] ?? ["1"];
  }

  List<int> scaleToIntervalList(List<String> scale) {
    var chromatic = defaultConfigs["Chromatic"]!;
    return scale.map((e) => chromatic.indexOf(e)).toList();
  }

  List<int> getRandomSetOfNotes() {
    var keys = activeConfigs.keys.where((key) => activeConfigs[key]!);
    // get activated scales
    if (keys.isEmpty) {
      return fallbackIntervals;
    }
    var scales = keys.map((e) {
      var scale = scaleByName(e); // find scale by name
      return scaleToIntervalList(scale);
    });
    var i = random.nextInt(scales.length);
    return scales.elementAt(i);
  }

  List<int> getPreviousNotes() => scaleHistory.getPreviousNotes();

  List<int> getNextNotes() {
    var notes = scaleHistory.getNextNotes();
    if (notes == null) {
      notes = getNewNotes();
      scaleHistory.addNotes(notes);
    }
    return notes;
  }

  List<int> getNewNotes() {
    var setOfNotes = getRandomSetOfNotes();
    int rootNote = random.nextInt(12);
    var out = [rootNote];
    while (out.length < min(1 + numberOfExtraNotes, setOfNotes.length * 3)) {
      var randomNote = setOfNotes[random.nextInt(setOfNotes.length)];
      var randomOctave = random.nextInt(3) * 12;
      var newNote = rootNote + randomOctave + randomNote;
      if (!out.contains(newNote)) out.add(newNote);
    }
    return out;
  }
}
