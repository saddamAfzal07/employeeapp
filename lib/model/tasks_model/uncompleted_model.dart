class RejectedTasks {
  String? taskId;
  String? taskStatus;
  String? assignedTaskSpecificId;
  List<Task>? task;

  RejectedTasks(
      {this.taskId, this.taskStatus, this.assignedTaskSpecificId, this.task});

  RejectedTasks.fromJson(Map<dynamic, dynamic> json) {
    taskId = json['task_id'];
    taskStatus = json['task_status'];
    assignedTaskSpecificId = json['assigned_task_specific_id'];
    if (json['task'] != null) {
      task = <Task>[];
      json['task'].forEach((v) {
        task!.add(new Task.fromJson(v));
      });
    }
  }

  Map toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['task_id'] = this.taskId;
    data['task_status'] = this.taskStatus;
    data['assigned_task_specific_id'] = this.assignedTaskSpecificId;
    if (this.task != null) {
      data['task'] = this.task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  int? id;
  String? taskTitle;
  String? taskDescription;

  Task({this.id, this.taskTitle, this.taskDescription});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTitle = json['task_title'];
    taskDescription = json['task_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_title'] = this.taskTitle;
    data['task_description'] = this.taskDescription;
    return data;
  }
}
