class Task {
  final List<int> notes;
  final List<String> solution;

  Task({required this.notes, required this.solution});
  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}