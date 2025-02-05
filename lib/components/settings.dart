
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_perfect_pitch_trainer/components/scale_picker/scale_picker.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    var settings = ref.watch(settingsProvider);
    var autoNext = settings.autoNext;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Difficulty: ${(settings.numberOfExtraNotes + 1).toInt()}'),
          Slider(
            value: settings.numberOfExtraNotes,
            max: 11,
            divisions: 11,
            min: 0,
            label: (settings.numberOfExtraNotes + 1).round().toString(),
            onChanged: (v) {
              ref.read(settingsProvider.notifier).numberOfExtraNotes = v;
            },
            onChangeEnd: (v) async {
              await ref.read(taskGeneratorProvider.notifier).getNextTask();
            },
          ),
          ScalePicker(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Switch(
                    value: autoNext,
                    onChanged: (n) async {
                      ref.read(settingsProvider.notifier).autoNext = n;
                      if (n) {
                       await ref.read(taskGeneratorProvider.notifier).getNextTask();
                      }
                    },
                  ),
                  Row(
                    children: [
                      Text(autoNext ? "AutoSkip: On After" : "AutoSkip: Off"),
                      if (autoNext) ...[
                        NumberPicker(
                          value: settings.skipTimeOut,
                          minValue: 3,
                          maxValue: 300,
                          step: 1,
                          itemHeight: 30,
                          haptics: true,
                          onChanged: (value) {
                            var settingsManager = ref.read(
                              settingsProvider.notifier,
                            );
                            settingsManager.skipTimeOut = value;
                          },
                        ),
                        const Text("Seconds"),
                      ],
                    ],
                  ),
                ],
              ),
              if (!autoNext)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch(
                      value: !settings.oneShot,
                      onChanged:
                          (n) =>
                              ref.read(settingsProvider.notifier).oneShot = !n,
                    ),
                    Text(
                      settings.oneShot ? "Loop Mode: Off " : "Loop Mode: On",
                    ),
                  ],
                ),
              if (autoNext)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch(
                      value: settings.callSolution,
                      onChanged:
                          (n) =>
                              ref.read(settingsProvider.notifier).callSolution =
                                  n,
                    ),
                    Text(
                      settings.callSolution
                          ? "Solution Call: On"
                          : "Solution Call: Off",
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
