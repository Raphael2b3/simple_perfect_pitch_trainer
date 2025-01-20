import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "scale_config.g.dart";

@riverpod
class ScaleConfigManager extends _$ScaleConfigManager {
  Map<String, List<String>> configs = {};
  static const String _storageKey = 'scale_config_manager';

  /// List of undeletable config keys

  final Map<String, List<String>> undeletableConfigs = const {
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

  @override
  Future<Map<String, List<String>>> build() async {
    return await _loadConfigs();
  }

  /// Loads the configs from local storage.
  Future<Map<String, List<String>>> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      // Convert dynamic map to Map<String, List<String>>
      configs = jsonMap.map(
        (key, value) =>
            MapEntry(key, List<String>.from(value as List<dynamic>)),
      );
    }

    return configs;
  }

  /// Updates a specific key with new values and stores the updated configs in local storage.
  Future<void> updateConfig(String key, List<String> values) async {
    configs[key] = values;
    await _saveConfigs();
  }

  /// Deletes a specific key from the configs and updates local storage, unless it is undeletable.
  Future<void> deleteConfig(String key) async {
    if (configs.keys.contains(key)) {
      throw Exception('Cannot delete undeletable config: $key');
    }
    configs.remove(key);
    await _saveConfigs();
  }

  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) {
    return configs.values.any((list) => list.contains(name));
  }

  /// Stores the configs into local storage.
  Future<void> _saveConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(configs);
    await prefs.setString(_storageKey, jsonString);
    state = await AsyncValue.guard(()async => configs);
  }

  /// Provides the current configs.
  Map<String, List<String>> get currentConfigs => configs;
}
