// import 'dart:io';

// class DailyTasks {
//   String? taskId;
//   String? taskStatus;
//   String? id;
//   List<Task>? task;
//   File? image;

//   DailyTasks({this.taskId, this.taskStatus, this.id, this.task, this.image});

//   DailyTasks.fromJson(Map<dynamic, dynamic> json) {
//     taskId = json['task_id'];
//     taskStatus = json['task_status'];
//     image = null;
//     id = json['id'].toString();
//     if (json['task'] != null) {
//       task = <Task>[];
//       json['task'].forEach((v) {
//         task!.add(new Task.fromJson(v));
//       });
//     }
//   }

//   Map toJson() {
//     final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
//     data['task_id'] = this.taskId;
//     data['task_status'] = this.taskStatus;
//     data['id'] = this.id;
//     if (this.task != null) {
//       data['task'] = this.task!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Task {
//   int? id;
//   String? taskTitle;
//   String? taskDescription;

//   Task({this.id, this.taskTitle, this.taskDescription});

//   Task.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     taskTitle = json['task_title'];
//     taskDescription = json['task_description'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['task_title'] = this.taskTitle;
//     data['task_description'] = this.taskDescription;
//     return data;
//   }
// }
import 'dart:io';

class DailyTasks {
  int? id;
  String? employeeId;
  File? image;
  String? taskId;
  String? shiftId;
  String? shiftDate;
  String? taskStatus;
  String? createdAt;
  String? updatedAt;
  List<Task>? task;
  String? load;

  DailyTasks(
      {this.id,
      this.load,
      this.employeeId,
      this.image,
      this.taskId,
      this.shiftId,
      this.shiftDate,
      this.taskStatus,
      this.createdAt,
      this.updatedAt,
      this.task});

  DailyTasks.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    image = json['image'];
    taskId = json['task_id'];
    shiftId = json['shift_id'];
    shiftDate = json['shift_date'];
    taskStatus = json['task_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['task'] != null) {
      task = <Task>[];
      json['task'].forEach((v) {
        task!.add(new Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['image'] = this.image;
    data['task_id'] = this.taskId;
    data['shift_id'] = this.shiftId;
    data['shift_date'] = this.shiftDate;
    data['task_status'] = this.taskStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  String? imageRequired;

  Task({this.id, this.taskTitle, this.taskDescription, this.imageRequired});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTitle = json['task_title'];
    taskDescription = json['task_description'];
    imageRequired = json['image_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_title'] = this.taskTitle;
    data['task_description'] = this.taskDescription;
    data['image_required'] = this.imageRequired;
    return data;
  }
}
