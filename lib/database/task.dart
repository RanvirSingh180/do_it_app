class Task {
  int? id;
  String name;
  int date;
  int isCompleted;
  int collectionId;

  Task(
      {this.id,
      required this.date,
      required this.name,
      required this.collectionId,
      required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'completed': isCompleted,
      'collectionId': collectionId
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, date: $date, completed:$isCompleted, collectionId:$collectionId}';
  }
}
