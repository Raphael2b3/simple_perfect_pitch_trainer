import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_perfect_pitch_trainer/components/scale_picker/scale_picker.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player/chord_player_controller.dart';
import 'package:simple_perfect_pitch_trainer/services/settings.dart';
import 'package:simple_perfect_pitch_trainer/services/task/task_generator.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  bool _autoNext = false;

  set autoNext(bool value) {
    if (value) {
      reInitTimer();
    } else {
      timer?.cancel();
    }
    setState(() {
      _autoNext = value;
    });
  }

  bool get autoNext => _autoNext;
  int skipTimeout = 15;
  Timer? timer;

  void reInitTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: skipTimeout), (Timer t) async {
      await ref.read(taskGeneratorProvider.notifier).getNextTask();
      await ref.read(chordPlayerControllerProvider.notifier).resume();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var settings = ref.watch(settingsProvider);


    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Number of Notes Played: ${settings.numberOfExtraNotes + 1}'),
          Slider(
            value: settings.numberOfExtraNotes,
            max: 11,
            divisions: 11,
            min: 0,
            label: (settings.numberOfExtraNotes + 1).round().toString(),
            onChanged: (v) {
              ref.read(settingsProvider.notifier).numberOfExtraNotes = v;
              v;
            },
          ),
          ScalePicker(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Switch(value: autoNext, onChanged: (n) => autoNext = n),
              Text(
                autoNext
                    ? "AutoSkip after"
                    : "AutoSkip deactivated",
              ),
              if (autoNext) ...[
                NumberPicker(
                  value: skipTimeout,
                  minValue: 3,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Switch(value: !settings.oneShot,
                  onChanged: (n) => ref.read(settingsProvider.notifier).oneShot = !n),
              Text(settings.oneShot?"Play Chord Once (One Shot)":"Repeat Chords"),

          ],)
        ],
      ),
    );
  }
}
