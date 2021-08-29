class Task {
  late String task;
  late String date;
  late bool completed;

  Task({required this.task, required this.date, required this.completed});

  Task.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    date = json['date'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    data['date'] = this.date;
    data['completed'] = this.completed;
    return data;
  }
}
