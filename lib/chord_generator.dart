import 'dart:math';



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

List<String> generateScale(int length, int maxInterval){
  final intervals = generateRandomIntervals(
    length,
    maxInterval,
  );
  final rootNote = generateRandomRootNote();
  var scale = generateScaleWithIntervals(rootNote, intervals);
  return scale;
}
