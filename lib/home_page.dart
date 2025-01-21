import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_perfect_pitch_trainer/scale_picker.dart';

import 'chord_generator.dart';
import 'chord_player.dart';
import 'chord_player_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool autoNext = false;
  int skipTimeout = 15;
  Timer? timer;
  void reInitTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: skipTimeout), (Timer t) async {
      if (autoNext) {
        await nextChord();
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

  Future nextChord() async {
    var chordPlayer = ref.read(chordPlayerProvider.notifier);
    //var scale = generateScale(numberOfExtraNotes.toInt(), maxInterval.toInt());
    //await chordPlayer.loadNewPlayer(scale);
    await chordPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    var chordPlayer = ref.read(chordPlayerProvider.notifier);
    var chordGenerator = ref.watch(chordGeneratorProvider.notifier);
    var numberOfExtraNotes = chordGenerator.numberOfExtraNotes;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ChordPlayerController(),
            Expanded(
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

                      setState(() {
                      chordGenerator.numberOfExtraNotes = v;
                      });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          await chordPlayer.pause();
                        },
                        child: const Text("Pause"),
                      ),
                      FilledButton(
                        onPressed: () async {
                          chordPlayer.resume();
                        },
                        child: const Text("Resume"),
                      ),
                      FilledButton(
                        onPressed: nextChord,
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
