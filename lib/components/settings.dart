import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_perfect_pitch_trainer/scale_picker.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player/chord_player_controller.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  bool autoNext = false;
  int skipTimeout = 15;
  Timer? timer;

  void reInitTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: skipTimeout), (Timer t) async {
      if (autoNext) {
        await ref.read(taskGeneratorProvider.notifier).getNextTask(); // TODO Stop the timer when not used
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // call a function every n seconds:
    reInitTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberOfExtraNotes = ref.watch(
      settingsProvider.select((v) => v.numberOfExtraNotes),
    );
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Number of Notes Played: ${numberOfExtraNotes + 1}'),
          Slider(
            value: numberOfExtraNotes,
            max: 11,
            divisions: 11,
            min: 0,
            label: (numberOfExtraNotes + 1).round().toString(),
            onChanged: (v) {
              ref.read(settingsProvider.notifier).numberOfExtraNotes = v;
              v;
            },
          ),
          ScalePicker(),
          Text(
            autoNext
                ? "Automaticly skip after $skipTimeout seconds"
                : "Automaticly skip deactivated",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: autoNext,
                onChanged: (n) {
                  setState(() {
                    autoNext = n;
                  });
                },
              ),
              if (autoNext) ...[
                NumberPicker(
                  value: skipTimeout,
                  minValue: 1,
                  maxValue: 300,
                  step: 1,
                  haptics: true,
                  onChanged:
                      (value) => setState(() {
                        skipTimeout = value;
                        reInitTimer();
                      }),
                ),
                const Text("seconds"),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
