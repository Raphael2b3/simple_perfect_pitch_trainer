class ScaleHistory{
  final List<List<int>> history = [];
  int historyIndex = 0; // higher value means further back in history

  List<int> getPreviousNotes() {
    var i = history.length - (historyIndex + 1);
    if (i < 0) {
      return history[0];
    }
    historyIndex++;
    return history[i];
  }


  List<int>? getNextNotes() {
    if (historyIndex <= 0) {
      return null;
    }
    var i = history.length - (historyIndex - 1);
    historyIndex--;
    return history[i];
  }

  void addNotes(List<int> notes) {
    history.add(notes);
    historyIndex = 0;
    history.add(notes);
    if (history.length > 50) {
      history.removeAt(0);
      print("Removed oldest history entry");
    }
  }
}
