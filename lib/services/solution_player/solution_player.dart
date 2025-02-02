import 'package:audioplayers/audioplayers.dart';
import 'package:simple_perfect_pitch_trainer/services/task/solution.dart';
const List<String> notes = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];

List<String> intervalsToFilenames(List<int> intervals) =>
    intervals.map((i) {
      assert(i >= 0 && i < 12);
      return "solutions/intervals/interval$i.mp3";
    }).toList();

List<String> solutionNoteFilenames(List<int> notesToPlay) =>
    notesToPlay.map((i) {
      var name = notes[i % 12];
      return "solutions/notes/solution_$name.mp3";
    }).toList();


Future<void> playSolution(Solution solution) async {
  var player = AudioPlayer();
  int index = 0;
  player.onPlayerComplete.listen((_) async {});

  // TODO play all solution sounds sequencially;
}
