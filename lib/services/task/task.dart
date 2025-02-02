import 'package:simple_perfect_pitch_trainer/services/task/solution.dart';

class Task {
  final List<int> notes;
  final Solution solution;

  Task({required this.notes, required this.solution});
  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}