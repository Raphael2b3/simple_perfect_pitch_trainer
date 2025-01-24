import 'package:simple_perfect_pitch_trainer/services/task/task.dart';

class TaskHistory {
  final List<Task> history = [];
  int historyIndex = 0; // higher value means further back in history

  Task getPreviousTask() {
    var i = history.length - (historyIndex + 1);
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
    var i = history.length - (historyIndex - 1);
    historyIndex--;
    return history[i];
  }

  void addTask(Task task) {
    history.add(task);
    historyIndex = 0;
    history.add(task);
    if (history.length > 50) {
      history.removeAt(0);
      print("Removed oldest history entry");
    }
  }
}
