import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScaleStorage {
  static const String _storageKey = 'scale_manager';

  Map<String, List<String>> customConfigs = {};
  Map<String, bool> activeConfigs = {};

  Future init() async {
    await _loadConfigs();
  }

  /// Loads the customConfigs and activeConfigs from local storage.
  Future<void> _loadConfigs() async {
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
  }

  /// Updates a specific key with new values and stores the updated customConfigs in local storage.
  Future<void> updateScaleConfig(String key, List<String> values) async {
    customConfigs[key] = values;
    await _saveConfigs();
  }

  /// Updates a specific key with new values and stores the updated customConfigs in local storage.
  Future<void> updateActiveConfig(String key, bool value) async {
    activeConfigs[key] = value;
    await _saveConfigs();
  }

  /// Deletes a specific key from the customConfigs and updates local storage, unless it is undeletable.
  Future<void> deleteConfig(String key) async {
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
  }
}
