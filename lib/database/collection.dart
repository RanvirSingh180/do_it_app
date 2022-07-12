class Collection {
  int? id;
  String name;
  int date;
  int color;

  Collection(
      {this.id,
      required this.name,
      required this.date,
      required this.color});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'date': date, 'color': color};
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'].toInt(),
      name: map['name'] ?? '',
      date: map['date']?.toInt() ?? 0,
      color: map['color']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Collection {id: $id, name: $name, date: $date,color:$color}';
  }
}
