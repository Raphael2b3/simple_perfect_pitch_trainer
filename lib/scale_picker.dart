import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/scale_editor.dart';

class ScalePicker extends ConsumerStatefulWidget {
  const ScalePicker({super.key});

  @override
  ConsumerState<ScalePicker> createState() => _ScalePickerState();
}

class _ScalePickerState extends ConsumerState<ScalePicker> {

  @override
  Widget build(BuildContext context) {
    var scale_config = ref.read(scaleConfigManagerProvider.notifier);

    return ScaleEditor();
  }
}
