import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';

part "scale_manager.g.dart";

@Riverpod(keepAlive: true)
class ScaleManager extends _$ScaleManager {
  static Random random = Random();
  ScaleStorage scaleStorage = ScaleStorage();

  @override
  Future<Map<String, ScaleConfig>> build() async {
    await scaleStorage.init();
    return scaleStorage.scaleConfigs!;
  }

  /// Checks if a name is already used in any config.
  bool isNameTaken(String name) => state.value?.keys.contains(name) ?? false;

  Future<void> updateScale(ScaleConfig newConfig, {String? oldName}) async {
    if (oldName == newConfig.name) oldName = null;

    var overriddenConfig = state.value?[newConfig.name];
    // active state should not be changed if the config is not custom
    if (overriddenConfig != null &&
        overriddenConfig.values != newConfig.values &&
        !overriddenConfig.isCustom) {
      return;
    }

    if (oldName != null && isNameTaken(newConfig.name)) return;

    await scaleStorage.updateScaleConfig(newConfig);
    await scaleStorage.deleteConfig(oldName);
    ref.notifyListeners();
  }

  Future createScale(ScaleConfig newConfig) async {
    if (isNameTaken(newConfig.name)) return;
    await scaleStorage.updateScaleConfig(newConfig);
    ref.notifyListeners();
  }

  Future deleteScale(String name) async {
    var oldConfig = state.value![name]!;
    if (!oldConfig.isCustom) return;
    await scaleStorage.deleteConfig(name);
    ref.notifyListeners();
  }

  void selectAll() {
    for (var scaleConfig in state.value?.values ?? <ScaleConfig>[]) {
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
