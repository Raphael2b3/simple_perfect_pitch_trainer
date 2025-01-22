import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "scale_manager.g.dart";

class ScaleConfig {
  final String name;
  final List<String> values;
  final bool active;

  ScaleConfig(this.name, this.values, this.active);

  factory ScaleConfig.fromJson(Map<String, dynamic> json) {
    return ScaleConfig(
      json['name'] as String,
      List<String>.from(json['values'] as List<dynamic>),
      json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'values': values, 'active': active};
  }
}

@riverpod
class ScaleManager extends _$ScaleManager {
  static const String _storageKey = 'scale_manager';
  static Random random = Random();
  final List<List<int>> history = [];
  int historyIndex = 0; // higher value means further back in history

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
  Map<String, List<String>> customConfigs = {};
  Map<String, bool> activeConfigs = {};

  @override
  Future<Map<String, bool>> build() async {
    ref.keepAlive();
    return await _loadConfigs();
  }

  bool isActive(String key) => activeConfigs[key] ?? false;

  bool isCustom(String key) => customConfigs.containsKey(key);

  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) =>
      customConfigs.keys.contains(name) || defaultConfigs.keys.contains(name);

  /// Loads the customConfigs and activeConfigs from local storage.
  Future<Map<String, bool>> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      customConfigs = (jsonMap['customConfigs'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, List<String>.from(value as List<dynamic>)),
      );

      activeConfigs = Map<String, bool>.from(jsonMap['activeConfigs'] ?? {});
    }

    for (var key in [...defaultConfigs.keys, ...customConfigs.keys]) {
      if (!activeConfigs.containsKey(key)) {
        activeConfigs[key] = false;
      }
    }
    return activeConfigs;
  }

  /// Updates a specific key with new values and stores the updated customConfigs in local storage.
  Future<void> updateConfig(String key, List<String> values) async {
    if (defaultConfigs.containsKey(key)) {
      throw Exception('Cannot update config: $key');
    }
    customConfigs[key] = values;
    await _saveConfigs();
  }

  /// Deletes a specific key from the customConfigs and updates local storage, unless it is undeletable.
  Future<void> deleteConfig(String key) async {
    if (defaultConfigs.containsKey(key)) {
      throw Exception('Cannot delete config: $key');
    }
    customConfigs.remove(key);
    activeConfigs.remove(key);
    await _saveConfigs();
  }

  /// Stores the customConfigs and activeConfigs into local storage.
  Future<void> _saveConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'customConfigs': customConfigs,
      'activeConfigs': activeConfigs,
    });
    await prefs.setString(_storageKey, jsonString);
    state = AsyncValue.data(activeConfigs);
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

  List<int> getNextNotes(int numberOfExtraNotes) {
    if (historyIndex <= 0) {
      var newNotes = getNewNotes(numberOfExtraNotes);
      history.add(newNotes);
      historyIndex == 0;
      return newNotes;
    }
    var i = history.length - (historyIndex - 1);
    historyIndex--;
    return history[i];
  }

  List<int> getNewNotes(int numberOfExtraNotes) {
    var setOfNotes = getRandomSetOfNotes();
    int rootNote = random.nextInt(12);
    var out = [rootNote];
    for (var i = 0; i < numberOfExtraNotes; i++) {
      var randomNote = setOfNotes[random.nextInt(setOfNotes.length)];
      var randomOctave = random.nextInt(3)*12;
      out.add(rootNote+randomOctave+randomNote);
    }
    return out;
  }
}
