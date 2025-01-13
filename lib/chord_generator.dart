import 'dart:math';
import "package:audioplayers/audioplayers.dart";

// Musiknoten
const List<String> notes = [
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
];

// Zufällige Intervalle erstellen
List<int> generateRandomIntervals(int length, int maxInterval) {
  final random = Random();
  return List.generate(
    length,
    (_) => random.nextInt(maxInterval) + 1,
  ); // Intervalle: 1 bis 3 Halbtöne
}

// Zufälligen Grundton generieren
String generateRandomRootNote() {
  final random = Random();
  return notes[random.nextInt(notes.length)];
}

// Berechne die Noten und Frequenzen basierend auf Intervallen und Grundton
List<String> generateScaleWithIntervals(String rootNote, List<int> intervals) {
  List<String> scale = ["${rootNote}1"];
  int currentIndex = notes.indexOf(rootNote);
  String suffix = "2";
  for (var step in intervals) {
    if (currentIndex + step >= notes.length) suffix = "3";
    currentIndex = (currentIndex + step) % notes.length;
    String noteName = notes[currentIndex];
    scale.add(noteName + suffix);
  }
  print('Skala: $scale');
  return scale;
}

class ChordPlayer {
  List<AudioPlayer> players = [];
  late String scale;
  static Future<ChordPlayer> create(List<String> scale) async {
    var chordPlayer = ChordPlayer();
    await chordPlayer.init(scale);
    return chordPlayer;
  }

  Future init(List<String> scale) async {
    for (var note in scale) {
      var newPlayer = AudioPlayer();
      this.scale = scale.toString();
      await newPlayer.setSourceAsset("$note.mp3");
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      players.add(newPlayer);
    }
  }

  Future resume() async {
    for (var player in players) {
      await player.resume();
    }
  }

  Future pause() async {
    for (var player in players) {
      await player.pause();
    }
  }

  Future dispose() async {
    for (var player in players) {
      await player.dispose();
    }
  }
}

