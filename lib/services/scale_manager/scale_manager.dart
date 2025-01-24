import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_history.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';

part "scale_manager.g.dart";

@riverpod
class ScaleManager extends _$ScaleManager {
  static Random random = Random();
  ScaleStorage scaleStorage = ScaleStorage();

  @override
  Future<Map<String, ScaleConfig>> build() async {
    await scaleStorage.init();
    return scaleStorage.scaleConfigs!;
  }

  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) => state.value!.keys.contains(name);

  Future activate(String key, bool value) async {
    var modified = state.value![key]!;
    var oldValue = modified.isActive;
    if (oldValue == value) return;
    modified.isActive = value;
    await scaleStorage.updateScaleConfig(modified);
    ref.notifyListeners();
  }

  void selectAll() {
    for (var scaleConfig in state.value!.values) {
      scaleConfig.isActive = true;
    }
    ref.notifyListeners();
  }

  void deselectAll() {
    for (var scaleConfig in state.value!.values) {
      scaleConfig.isActive = false;
    }
    ref.notifyListeners();
  }

}
