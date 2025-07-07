class Task {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  /// Factory untuk membuat Task dari Map Supabase
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['due_date']),
      isCompleted: map['is_completed'] as bool,
    );
  }

  /// Konversi Task ke Map (untuk insert ke Supabase)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  /// Copy Task dengan update field tertentu
  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
