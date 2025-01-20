import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/components/config_item.dart';
import 'package:simple_perfect_pitch_trainer/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/scale_editor.dart';

class ScalePicker extends ConsumerStatefulWidget {
  const ScalePicker({super.key});

  @override
  ConsumerState<ScalePicker> createState() => _ScalePickerState();
}

class _ScalePickerState extends ConsumerState<ScalePicker> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var scale_config = ref.watch(scaleConfigManagerProvider);
    var scale_config_manager = ref.read(scaleConfigManagerProvider.notifier);

    if (expanded) {
      return Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: () {}, child: Text("Select All")),
                TextButton(onPressed: () {}, child: Text("Deselect All")),
                TextButton(onPressed: () {}, child: Text("Add New")),
                FilledButton(onPressed: () {}, child: Text("Save")),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ...scale_config_manager.undeletableConfigs.keys.map(
                    (key) => ConfigItem(name: key),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return FilledButton(onPressed: (){}, child: Text("Select Scales"));
  }
}
