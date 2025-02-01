import 'package:simple_perfect_pitch_trainer/services/task/task.dart';

class TaskHistory {
  final List<Task> history = [];
  int historyIndex = 0; // higher value means further back in history

  Task getPreviousTask() {
    var i = history.length - 2 - historyIndex;
    if (i < 0) {
      return history[0];
    }
    historyIndex++;
    return history[i];
  }

  Task? getNextTask() {
    if (historyIndex <= 0) {
      return null;
    }
    // historyIndex is 1 or higher
    // [i4, i3, i2, i1, i0] history index
    // (history.length - 1) = last index
    historyIndex--; // go less to the past
    var i = (history.length - 1) - historyIndex;
    return history[i];
  }

  void addTask(Task task) {
    history.add(task);
    historyIndex = 0;
    if (history.length > 50) {
      history.removeAt(0);
      print("Removed oldest history entry");
    }
  }
}
