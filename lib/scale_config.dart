import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "scale_config.g.dart";

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
class ScaleConfigManager extends _$ScaleConfigManager {
  static const String _storageKey = 'scale_config_manager';
  static Random random = Random();
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

  Map<String, List<String>> customConfigs = {};
  Map<String, bool> activeConfigs = {};

  List<String> scaleByName(String name) {
    return defaultConfigs[name] ?? customConfigs[name] ?? ["1"];
  }

  List<int> scaleToIntervalList(List<String> scale) {
    var chromatic = defaultConfigs["Chromatic"]!;

    return scale.map((e) => chromatic.indexOf(e)).toList();
  }

  List<int> getRandomScale() {
    var keys = activeConfigs.keys.where((key) => activeConfigs[key]!);
    // get activated scales
    var scales = keys.map((e) {
      var scale = scaleByName(e); // find scale by name
      // convert scale to integer offsets
      return scaleToIntervalList(scale);
    });
    var i = random.nextInt(scales.length);
    return scales.elementAt(i);
  }

  bool isActive(String key) => activeConfigs[key] ?? false;

  bool isCustom(String key) => customConfigs.containsKey(key);

  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) =>
      customConfigs.keys.contains(name) || defaultConfigs.keys.contains(name);

  void setActivate(String key, bool value) {
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

  @override
  Future<Map<String, bool>> build() async => await _loadConfigs();

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
      throw Exception('Cannot update undeletable config: $key');
    }
    customConfigs[key] = values;
    await _saveConfigs();
  }

  /// Deletes a specific key from the customConfigs and updates local storage, unless it is undeletable.
  Future<void> deleteConfig(String key) async {
    if (defaultConfigs.containsKey(key)) {
      throw Exception('Cannot delete undeletable config: $key');
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
    state = await AsyncValue.guard(() async => activeConfigs);
  }
}
