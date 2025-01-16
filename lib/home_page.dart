import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import 'chord_generator.dart';
import 'chord_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double numberOfNotes = 5;
  double maxInterval = 3;
  bool autoNext = false;
  int skipTimeout = 30;

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
    var scale = generateScale(numberOfNotes.toInt(), maxInterval.toInt());
    await chordPlayer.loadNewPlayer(scale);
    await chordPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    var chordPlayer = ref.read(chordPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ChordController(),
            Column(
              children: [
                Text('Number of Notes Played: ${numberOfNotes + 1}'),
                Slider(
                  value: numberOfNotes,
                  max: 11,
                  divisions: 11,
                  min: 0,
                  label: (numberOfNotes + 1).round().toString(),
                  onChanged: (v) {
                    setState(() {
                      numberOfNotes = v;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text('Maximum Interval: $maxInterval'),
                Slider(
                  value: maxInterval,
                  max: 12,
                  divisions: 11,
                  min: 1,
                  label: (maxInterval).round().toString(),
                  onChanged: (v) {
                    setState(() {
                      maxInterval = v;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
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
                        minValue: 0,
                        maxValue: 300,
                        step: 1,
                        haptics: true,
                        onChanged:
                            (value) =>
                            setState(() {
                              skipTimeout = value;
                              reInitTimer();
                            }),
                      ),
                      Text("seconds"),
                    ],
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () async {
                    await chordPlayer.pause();
                  },
                  child: Text("Pause"),
                ),
                FilledButton(
                  onPressed: () async {
                    chordPlayer.resume();
                  },
                  child: Text("Resume"),
                ),
                FilledButton(onPressed: nextChord, child: Text("Next")),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
