class Person {
  final String id;
  final String name;
  final DateTime? birthDate;
  final String no_telp;
  String email;

  Person({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.no_telp,
    this.email = "Unknown",
  });

  int get Age {
    if (birthDate == null) throw Exception("Birth date can't be null");
    DateTime now = DateTime.now();
    int age = now.year - birthDate!.year;

    if (birthDate!.year < now.year ||
        (birthDate!.month == now.month && birthDate!.day < now.day))
      age--;
    return age;
  }
}

class Task {
  final String id;
  final String title;
  String priority;
  bool isDone;
  DateTime assigned;
  DateTime deadline;

  Task({
    required this.id,
    required this.title,
    this.priority = "",
    this.isDone = false,
    required this.assigned,
    required this.deadline,
  }) : assert(
         assigned.isBefore(deadline),
         "Assignment day must be more than the Deadline day",
       ) {
    final diffDay = deadline.difference(assigned).inDays;

    if (diffDay >= 3)
      priority = "High";
    else if (diffDay == 2)
      priority = "Medium";
    else
      priority = "Low";
  }

  void completedTask() => isDone = true;
}

class Manajemen {
  List<Task> _task = [];

  Task getTaskID(String id) {
    return _task.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception("Task with ID ($id) not found"),
    );
  }

  void addTask(Task task) {
    if (_task.contains(task.id) && _task.contains(task.title))
      throw Exception("Task already added");

    // if (_task.contains(task.priority = "High"))
    _task.add(task);
    print("Task (${task.title}) added");
  }
}

void main() {
  try {
    var task1 = Task(
      id: "T001",
      title: "Brain Illness",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 11, 11, 30),
    );

    var task2 = Task(
      id: "T002",
      title: "Human Thinking",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 11, 11, 30),
    );

    print(task1.priority);
  } catch (e) {
    print("Error : $e");
  }
}
