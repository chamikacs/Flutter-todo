class Todo {
  final String? id;
  final String title;
  final String description;
  final DateTime? deadline;
  final String? image;
  final DateTime? createdAt;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.image,
    this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      image: json['image'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return "$title, $description, $deadline, $image, $createdAt";
  }
}
