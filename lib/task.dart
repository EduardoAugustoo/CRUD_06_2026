class Task {
  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }
}
