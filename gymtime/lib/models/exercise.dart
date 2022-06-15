class Exercise {
  final int? id;
  final String? name;
  late final int? time;

  Exercise({this.id, this.name, this.time});

  factory Exercise.fromMap(Map<String, dynamic> json) =>
      Exercise(id: json['id'], name: json['name'], time: json['time']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'time': time};
  }
}
