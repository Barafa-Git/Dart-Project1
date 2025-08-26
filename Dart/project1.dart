enum Priority { high, medium, low }

enum TaskStatus { pending, completed, overdue }

class Task {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final String category;
  final DateTime assignedDate;
  final DateTime deadline;
  TaskStatus status;
  DateTime? completedDate;

  Task({
    required this.id,
    required this.title,
    this.description = "",
    required this.priority,
    required this.category,
    required this.assignedDate,
    required this.deadline,
  }) : status = TaskStatus.pending {
    if (deadline.isBefore(assignedDate)) {
      throw Exception("Deadline cannot be before assigned date");
    }

    // Update status if task is already overdue
    if (DateTime.now().isAfter(deadline)) {
      status = TaskStatus.overdue;
    }
  }

  void completeTask() {
    if (DateTime.now().isAfter(deadline)) {
      status = TaskStatus.overdue;
      throw Exception("Cannot complete task: deadline has passed");
    }

    status = TaskStatus.completed;
    completedDate = DateTime.now();
  }

  void updateStatus() {
    if (status != TaskStatus.completed && DateTime.now().isAfter(deadline)) {
      status = TaskStatus.overdue;
    }
  }

  int get daysUntilDeadline {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  bool get isDueSoon => daysUntilDeadline <= 3 && status == TaskStatus.pending;
}

class TaskManager {
  final List<Task> _tasks = [];

  void addTask(Task task) {
    // Check for duplicate task (same title in same category)
    if (_tasks.any(
      (t) =>
          t.title == task.title &&
          t.category == task.category &&
          t.status != TaskStatus.completed,
    )) {
      throw Exception("Task with same title already exists in this category");
    }

    // Check for high priority task limit (only pending ones)
    if (task.priority == Priority.high) {
      final highPriorityCount = _tasks
          .where(
            (t) =>
                t.priority == Priority.high && t.status == TaskStatus.pending,
          )
          .length;

      if (highPriorityCount >= 5) {
        throw Exception("Cannot have more than 5 active high priority tasks");
      }
    }

    _tasks.add(task);
    print("Task '${task.title}' added successfully");
  }

  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    print("Task removed successfully");
  }

  void completeTask(String taskId) {
    final task = _getTaskById(taskId);
    task.completeTask();
    print("Task '${task.title}' marked as completed");
  }

  Task _getTaskById(String id) {
    return _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception("Task with ID $id not found"),
    );
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<Task> getTasksByPriority(Priority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> searchTasks(String keyword) {
    final searchTerm = keyword.toLowerCase();
    return _tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(searchTerm) ||
              task.description.toLowerCase().contains(searchTerm),
        )
        .toList();
  }

  List<Task> getDueSoonTasks() {
    return _tasks.where((task) => task.isDueSoon).toList();
  }

  void updateAllStatuses() {
    for (final task in _tasks) {
      task.updateStatus();
    }
  }

  Map<String, int> getProductivityStats() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final weeklyCompleted = _tasks
        .where(
          (task) =>
              task.status == TaskStatus.completed &&
              task.completedDate != null &&
              task.completedDate!.isAfter(startOfWeek),
        )
        .length;

    return {
      'total': _tasks.length,
      'completed': _tasks
          .where((task) => task.status == TaskStatus.completed)
          .length,
      'pending': _tasks
          .where((task) => task.status == TaskStatus.pending)
          .length,
      'overdue': _tasks
          .where((task) => task.status == TaskStatus.overdue)
          .length,
      'weekly_completed': weeklyCompleted,
    };
  }

  void displayTasks(List<Task> tasks, {String title = "TASKS"}) {
    print("\n$title");
    print("=" * 50);

    if (tasks.isEmpty) {
      print("No tasks found");
      return;
    }

    for (final task in tasks) {
      final statusIcon = task.status == TaskStatus.completed
          ? "✓"
          : task.status == TaskStatus.overdue
          ? "!"
          : "•";

      print(
        "$statusIcon [${task.priority.toString().split('.').last.toUpperCase()}] ${task.title}",
      );
      print("  Category: ${task.category}");
      print(
        "  Due: ${task.deadline.toString().split(' ')[0]} (in ${task.daysUntilDeadline} days)",
      );
      print("  Status: ${task.status.toString().split('.').last}");

      if (task.status == TaskStatus.completed && task.completedDate != null) {
        print("  Completed: ${task.completedDate.toString().split(' ')[0]}");
      }

      print("-" * 30);
    }
  }
}

void main() {
  try {
    final manager = TaskManager();
    final now = DateTime.now();

    // Add some tasks
    manager.addTask(
      Task(
        id: "1",
        title: "Presentasi Proyek X",
        description: "Persiapan presentasi untuk klien",
        priority: Priority.high,
        category: "Pekerjaan",
        assignedDate: now,
        deadline: now.add(Duration(days: 7)), // deadline 7 hari ke depan
      ),
    );

    manager.addTask(
      Task(
        id: "2",
        title: "Review Laporan",
        description: "Review laporan keuangan bulanan",
        priority: Priority.medium,
        category: "Pekerjaan",
        assignedDate: now,
        deadline: now.add(Duration(days: 2)), // deadline 2 hari ke depan
      ),
    );

    manager.addTask(
      Task(
        id: "3",
        title: "Belanja Bulanan",
        description: "Belanja kebutuhan bulanan",
        priority: Priority.low,
        category: "Pribadi",
        assignedDate: now,
        deadline: now.add(Duration(days: 4)), // deadline 4 hari ke depan
      ),
    );

    // Display all tasks
    manager.displayTasks(
      manager.getTasksByStatus(TaskStatus.pending),
      title: "PENDING TASKS",
    );

    // Complete a task
    manager.completeTask("2");

    // Search tasks
    final searchResults = manager.searchTasks("presentasi");
    manager.displayTasks(searchResults, title: "SEARCH RESULTS");

    // Show due soon tasks
    manager.displayTasks(manager.getDueSoonTasks(), title: "DUE SOON TASKS");

    // Show statistics
    print("\nPRODUCTIVITY STATS");
    print("=" * 30);
    final stats = manager.getProductivityStats();
    stats.forEach((key, value) {
      print("${key.replaceAll('_', ' ').toUpperCase()}: $value");
    });
  } catch (e) {
    print("Error: $e");
  }
}
