import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_history.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';

import '../number_of_extra_notes.dart';

part "scale_manager.g.dart";

@riverpod
class ScaleManager extends _$ScaleManager {
  static Random random = Random();
  ScaleStorage scaleStorage = ScaleStorage();
  ScaleHistory scaleHistory = ScaleHistory();

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

  bool isActive(String key) => activeConfigs[key] ?? false;
  bool isCustom(String key) => customConfigs.containsKey(key);
  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) =>
      customConfigs.keys.contains(name) || defaultConfigs.keys.contains(name);

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

  void activate(String key, bool value) {
    activeConfigs[key] = value;
    _saveConfigs();
    state = AsyncValue.data({...activeConfigs});
  }

  void selectAll() {
    var keys = activeConfigs.keys.toList();
    for (var key in keys) {
      activeConfigs[key] = true;
    }
    _saveConfigs();
    state = AsyncValue.data({...activeConfigs});
  }

  void deselectAll() {
    var keys = activeConfigs.keys.toList();
    for (var key in keys) {
      activeConfigs[key] = false;
    }
    _saveConfigs();
    state = AsyncValue.data({...activeConfigs});
  }

  List<int> getPreviousNotes() {
    var i = history.length - (historyIndex + 1);
    if (i < 0) {
      return history[0];
    }
    historyIndex++;
    return history[i];
  }

  List<int> getNextNotes() {
    if (historyIndex <= 0) {
      var newNotes = getNewNotes();
      history.add(newNotes);
      if (history.length > 50) {
        history.removeAt(0);
        print("Removed oldest history entry");
      }
      historyIndex = 0;
      return newNotes;
    }
    var i = history.length - (historyIndex - 1);
    historyIndex--;
    return history[i];
  }

  List<int> getNewNotes() {
    var numberOfExtraNotes = ref.read(numberOfExtraNotesProvider);
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
