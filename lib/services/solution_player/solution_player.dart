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

const List<String> INTERVALS = [
  "1",
  "b2",
  "2",
  "b3",
  "3",
  "4",
  "b5",
  "5",
  "b6",
  "6",
  "7",
  "j7",
];

List<String> intervalsToFilenames(List<String> intervals) =>
    intervals.map((i) {
      print(i);
      print(INTERVALS);
      var j = INTERVALS.indexOf(i);
      return "solutions/intervals/interval$j.mp3";
    }).toList();

List<String> solutionNoteFilenames(List<int> notesToPlay) =>
    notesToPlay.map((i) {
      var name = notes[i % 12];
      return "solutions/notes/solution_$name.mp3";
    }).toList();

Future<void> playSolution(Solution solution,
    bool noteNames,
    bool intervals,) async {
  var player = AudioPlayer();
  player.onPlayerComplete.listen((e) => 0);
  await player.setReleaseMode(ReleaseMode.stop);
  await player.setPlayerMode(PlayerMode.mediaPlayer);
  if (noteNames) {
    var filenames = solutionNoteFilenames(solution.noteIds);
    for (var filename in filenames) {
      await player.setSourceAsset(filename);
      await player.resume();
      await player.onPlayerComplete.first;
    }
  }
  if (intervals) {
    var filenames = intervalsToFilenames(solution.intervals);
    for (var filename in filenames) {
      await player.setSourceAsset(filename);
      await player.resume();
      await player.onPlayerComplete.first;
    }
  }

  await player.dispose();
}
