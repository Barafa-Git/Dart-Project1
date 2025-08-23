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
    if (deadline.day - assigned.day >= 3)
      priority = "High";
    else if (deadline.day - assigned.day == 2)
      priority = "Medium";
    else
      priority = "Low";
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

    print(task1.priority);
  } catch (e) {
    print("Error : $e");
  }
}
