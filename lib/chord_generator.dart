import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/scale_config.dart';

part 'chord_generator.g.dart';

@riverpod
class ChordGenerator extends _$ChordGenerator {
  static Random random = Random();

  // Musiknoten
  static const List<String> notes = [
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

  double numberOfExtraNotes = 1;

  @override
  List<String> build() {

    return getNewNotes();
  }

  List<String> getNewNotes() {
    var scaleManager = ref.read(scaleConfigManagerProvider.notifier);
    var rootNoteIndex = random.nextInt(notes.length);

    var scale = scaleManager.getRandomScale();
    var out = ["${notes[rootNoteIndex]}1"];
    for (var i = 0; i < numberOfExtraNotes; i++) {
      var j = random.nextInt(scale.length);
      var interval = scale[j];
      var nextNoteIndex = (rootNoteIndex + interval) % notes.length;
      var register = 1+random.nextInt(3);
      out.add("${notes[nextNoteIndex]}$register");
    }
    return out;
  }

}
