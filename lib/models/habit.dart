class Habit {
  String name;
  String note;
  bool isPinned;
  List<bool> history;

  Habit({
    required this.name,
    this.note = '',
    this.isPinned = false,
    List<bool>? history,
  }) : history = history ?? List<bool>.filled(7, false, growable: true);

  int get streak {
    int count = 0;
    for (int i = history.length - 1; i >= 0; i--) {
      if (history[i]) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'note': note,
      'isPinned': isPinned,
      'history': history,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'],
      note: map['note'] ?? '',
      isPinned: map['isPinned'] ?? false,
      history: List<bool>.from(map['history']),
    );
  }
}
