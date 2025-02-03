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

const List<String> intervals = [
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
      var j = intervals.indexOf(i);
      return "solutions/intervals/interval$j.mp3";
    }).toList();

List<String> solutionNoteFilenames(List<int> notesToPlay) =>
    notesToPlay.map((i) {
      var name = notes[i % 12];
      return "solutions/notes/solution_$name.mp3";
    }).toList();

Future<void> playSolution(
  Solution solution,
  bool noteNames,
  bool intervals,
) async {
  print("[[[[[[[[[[ Playing Solution ]]]]]]]]]]");
  print("NoteNames: $noteNames");
  print("Intervals: $intervals");

  var player = AudioPlayer();
  await player.setReleaseMode(ReleaseMode.stop);
  await player.setPlayerMode(PlayerMode.mediaPlayer);
  if (noteNames) {
    var filenames = solutionNoteFilenames(solution.noteIds);
    print('Notename $filenames');
    for (var filename in filenames) {
      print("Solution: $filename");
      await player.setSourceAsset(filename);
      await player.seek(Duration.zero);
      await player.resume();
      await player.onPlayerComplete.single;
    }
  }
  if (intervals) {
    var filenames = intervalsToFilenames(solution.intervals);
    print("Filenames: $filenames");
    for (var filename in filenames) {
      print("Interval: $filename");
      await player.setSourceAsset(filename);
      await player.seek(Duration.zero);
      await player.resume();
      await player.onPlayerComplete.single;
    }
  }

  await player.dispose();
  print("[[[[[[[[[[ Solution Played ]]]]]]]]]]");
}
