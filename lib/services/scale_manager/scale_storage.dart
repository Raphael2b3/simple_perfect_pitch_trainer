import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';

class ScaleStorage {
  static const String _storageKey = 'scale_manager';
  static const Map<String, List<String>> _defaultConfigs = {
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
    "Chord m7": ["1","b3","5","7"],
    "Chord j7": ["1","3","5","j7"],
    "Chord 7": ["1","3","5","7"],
    "Chord m7b5": ["1","b3","b5","7"],
    "Full Diminished": ["1","b3","b5","6"],
    'Ionian': ["1", "2", "3", "4", "5", "6", "j7"],
    'Dorian': ["1", "2", "b3", "4", "5", "6", "7"],
    'Phrygian': ["1", "b2", "b3", "4", "5", "b6", "7"],
    'Lydian': ["1", "2", "3", "b5", "5", "6", "j7"],
    'Mixolydian': ["1", "2", "3", "4", "5", "6", "7"],
    'Aeolian': ["1", "2", "b3", "4", "5", "b6", "7"],
    'Locrian': ["1", "b2", "b3", "4", "b5", "b6", "7"],
    "Major Pentatonic": ["1", "2", "3", "5", "6"],
    "Minor Pentatonic": ["1", "b3", "4", "5", "7"],
    "Blues": ["1", "b3", "4", "b5", "5", "7"],
    "Whole Tone": ["1", "2", "3", "b5", "b6", "7"],
    "Melodic Minor": ["1", "2", "b3", "4", "5", "6", "j7"],
    "Harmonic Minor": ["1", "2", "b3", "4", "5", "b6", "j7"],
    "Diminished": ["1", "b2", "b3", "3", "b5", "5", "6", "j7"],
    "Augmented": ["1", "b3", "3", "5", "j7"],
  };

  Map<String, ScaleConfig>? scaleConfigs;

  Future init() async {
    var (customConfigs, activeConfigs) = await _loadConfigs();
    var newScaleConfigs = Map.fromEntries(
      customConfigs.keys
              .map(
                (key) => MapEntry(
                  key,
                  ScaleConfig(
                    isActive: activeConfigs[key] ?? false,
                    name: key,
                    values: customConfigs[key]!,
                    isCustom: true,
                  ),
                ),
              )
              .toList() +
          _defaultConfigs.keys
              .map(
                (key) => MapEntry(
                  key,
                  ScaleConfig(
                    isActive: activeConfigs[key] ?? false,
                    name: key,
                    values: _defaultConfigs[key]!,
                    isCustom: false,
                  ),
                ),
              )
              .toList(),
    );
    scaleConfigs = newScaleConfigs;
  }

  /// Loads the customConfigs and activeConfigs from local storage.
  Future<(Map<String, List<String>>, Map<String, bool>)> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return (<String, List<String>>{}, <String, bool>{});
    }

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString ?? "{}");
    var customConfigs =
        ((jsonMap['customConfigs'] ?? {}) as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(key, List<String>.from(value as List<dynamic>)),
        );
    var activeConfigs = Map<String, bool>.from(jsonMap['activeConfigs'] ?? {});

    return (customConfigs, activeConfigs);
  }

  /// Updates a specific key with new values and stores the updated customConfigs in local storage.
  Future<void> updateScaleConfig(ScaleConfig newConfig) async {
    var old = scaleConfigs?[newConfig.name];
    if (old != null && old.values != newConfig.values && !old.isCustom) return;
    scaleConfigs![newConfig.name] = newConfig;
    await _saveConfigs();
  }

  /// Deletes a specific key from the customConfigs and updates local storage, unless it is undeletable.
  Future<void> deleteConfig(String? key) async {
    if (key == null) return;
    var old = scaleConfigs?[key];
    if (old != null && !old.isCustom) return;
    scaleConfigs!.remove(key);
    await _saveConfigs();
  }

  /// Stores the customConfigs and activeConfigs into local storage.
  Future<void> _saveConfigs() async {
    var customConfigs = {};
    var activeConfigs = {};
    for (var conf in scaleConfigs!.values) {
      if (conf.isCustom) {
        customConfigs[conf.name] = conf.values;
      }
      activeConfigs[conf.name] = conf.isActive;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'customConfigs': customConfigs,
      'activeConfigs': activeConfigs,
    });
    await prefs.setString(_storageKey, jsonString);
  }
}
