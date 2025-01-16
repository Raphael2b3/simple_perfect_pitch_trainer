
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                FilledButton(
                  onPressed: () async {
                    var scale = generateScale(
                      numberOfNotes.toInt(),
                      maxInterval.toInt(),
                    );
                    await chordPlayer.loadNewPlayer(scale);
                  },
                  child: Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
