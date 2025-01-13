
import 'package:flutter/material.dart';
import 'package:impro_king/chord_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impro King',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Impro King'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> chords = const [];

  ChordPlayer? currentPlayer;
  double numberOfNotes = 5;
  double max_interval = 3;
  String? get status => currentPlayer?.players.first.state.toString();
  Future next() async {
    // Schritt 1: Zufällige Intervalle generieren
    final intervals = generateRandomIntervals(numberOfNotes.toInt(), max_interval.toInt());

    // Schritt 2: Zufälligen Grundton generieren
    final rootNote = generateRandomRootNote();

    // Schritt 3: Noten und Frequenzen basierend auf Intervallen berechnen
    final scale = generateScaleWithIntervals(rootNote, intervals);

    // Schritt 4: Akkord abspielen
    currentPlayer = await ChordPlayer.create(scale);
    currentPlayer?.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
          Text("Status: $status"),
            Text("Scale: ${currentPlayer?.scale}"),
            Column(
              children: [
                Text('Number of Notes Played: ${numberOfNotes+1}'),
                Slider(value: numberOfNotes,max: 11, divisions: 11, min:0, label: (numberOfNotes+1).round().toString(),onChanged: (v){
                  setState(() {
                    numberOfNotes = v;
                });}),
              ],
            ),
            Column(
              children: [
                Text('Maximum Interval: $max_interval'),

                Slider(value: max_interval,max: 12, divisions: 11, min:1, label: (max_interval).round().toString(),onChanged: (v){
                  setState(() {
                    max_interval = v;
                  });}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                FilledButton(
                  onPressed: () async {
                    await currentPlayer?.pause();
                    setState(() {});
                  },
                  child: Text("Pause"),
                ),
                FilledButton(
                  onPressed: () async {
                    await currentPlayer?.resume();
                    setState(() {});

                  },
                  child: Text("Resume"),
                ),
                FilledButton(
                  onPressed: () async {
                    await currentPlayer?.dispose();
                    await next();
                    setState(() {});

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
