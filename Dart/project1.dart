class Task {
  final String id;
  final String title;
  String priority;
  bool isDone;
  DateTime assigned;
  DateTime deadline;
  DateTime? submitDate;

  Task({
    required this.id,
    required this.title,
    this.priority = "",
    this.isDone = false,
    required this.assigned,
    required this.deadline,
    this.submitDate,
  }) : assert(submitDate != null, "This task hasn't been submitted yet.") {
    if (deadline.isBefore(assigned))
      throw Exception("Assignment day must be more than the Deadline day");

    final diffDay = deadline.difference(assigned).inDays;

    if (diffDay >= 3)
      priority = "Low";
    else if (diffDay == 2)
      priority = "Medium";
    else
      priority = "High";
  }

  void completedTask(DateTime submitDate) {
    if (submitDate.isBefore(assigned)) {
      throw Exception("Task cannot be submitted before it is assigned");
    }
    if (submitDate.isAfter(deadline)) {
      throw Exception("Deadline missed! Task cannot be submitted");
    }

    isDone = true;
  }
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

    var highPriorityTask = _task.where((t) => t.priority == "High").toList();

    if (highPriorityTask.length > 5)
      throw Exception(
        "Can't add more high priority tasks in the same time, the maximum is 5",
      );

    _task.add(task);
    print("Task (${task.title}) added");
  }

  void submitTask(Task task, DateTime submitDate) {
    task.completedTask(submitDate);
    task.submitDate = submitDate;
    // _task.remove(task);
    print("Task (${task.title}) submitted successfully on $submitDate");
  }

  void checkStatusTask({required bool status}) {
    var Task = _task.where((t) => t.isDone == status).toList();

    if (status == true)
      print("COMPLETED TASK");
    else
      print("ASSIGNED TASK");
    print("=====================");

    for (var item in Task) {
      print("ID       : ${item.id}");
      print("Title    : ${item.title}");
      print("Priority : ${item.priority}");
      print("Date Assigned : ${item.assigned}");
      print("Deadline : ${item.deadline}");
      print("Submit Date   : ${item.submitDate}");
      print("=====================");
    }
  }

  void orderByPriority(String priority) {
    var task = _task
        .where((t) => t.priority.toLowerCase() == priority.toLowerCase())
        .toList();

    if (task.isEmpty) throw Exception("There are no $priority priority tasks");

    print("TASK PRIORITY : $priority");
    print("=======================");
    for (var item in task) {
      print("ID       : ${item.id}");
      print("Title    : ${item.title}");
      print("Date Assigned : ${item.assigned}");
      print("Deadline : ${item.deadline}");
      print("Submit Date   : ${item.submitDate}");
      print("=====================");
    }
  }
}

void main() {
  try {
    var task1 = Task(
      id: "T001",
      title: "Brain Illness",
      assigned: DateTime(2025, 9, 10, 12, 30),
      deadline: DateTime(2025, 9, 11, 11, 30),
    );

    var task2 = Task(
      id: "T002",
      title: "Human Thinking",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 13, 11, 30),
    );

    var task3 = Task(
      id: "T003",
      title: "Human Evolution",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 13, 11, 30),
    );

    var task4 = Task(
      id: "T004",
      title: "Neuro Scient",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 13, 11, 30),
    );

    var task5 = Task(
      id: "T005",
      title: "Human Thinking",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 13, 11, 30),
    );

    var task6 = Task(
      id: "T006",
      title: "Human Resource",
      assigned: DateTime(2025, 9, 12, 12, 30),
      deadline: DateTime(2025, 9, 13, 11, 30),
    );

    print(task1.priority);

    var manajemen = Manajemen();
    manajemen.addTask(task1);
    manajemen.addTask(task2);
    manajemen.addTask(task3);
    manajemen.addTask(task4);
    manajemen.addTask(task5);
    manajemen.addTask(task6);

    manajemen.submitTask(task1, DateTime(2025, 9, 11, 10, 00));

    manajemen.checkStatusTask(status: false);
    print("");
    manajemen.orderByPriority("High");
  } catch (e) {
    print("$e");
  }
}
