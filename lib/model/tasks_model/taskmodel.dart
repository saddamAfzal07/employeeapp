import 'dart:io';

class Tasksss {
  int? id;
  String? employeeId;
  String? taskTitle;
  String? taskDescription;
  String? status;
  String? taskDate;
  String? shiftId;
  Null? taskPoints;
  Null? taskType;
  Null? taskStartDate;
  Null? taskEndDate;
  String? createdAt;
  String? updatedAt;
  Shifts? shifts;
  File? image;

  Tasksss(
      {this.id,
      this.employeeId,
      this.taskTitle,
      this.taskDescription,
      this.status,
      this.taskDate,
      this.shiftId,
      this.taskPoints,
      this.taskType,
      this.taskStartDate,
      this.taskEndDate,
      this.createdAt,
      this.updatedAt,
      this.shifts,
      this.image});

  Tasksss.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    taskTitle = json['task_title'];
    taskDescription = json['task_description'];
    status = json['status'];
    taskDate = json['task_date'];
    shiftId = json['shift_id'];
    taskPoints = json['task_points'];
    taskType = json['task_type'];
    taskStartDate = json['task_start_date'];
    taskEndDate = json['task_end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = null;
    shifts =
        json['shifts'] != null ? new Shifts.fromJson(json['shifts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['task_title'] = this.taskTitle;
    data['task_description'] = this.taskDescription;
    data['status'] = this.status;
    data['task_date'] = this.taskDate;
    data['shift_id'] = this.shiftId;
    data['task_points'] = this.taskPoints;
    data['task_type'] = this.taskType;
    data['task_start_date'] = this.taskStartDate;
    data['task_end_date'] = this.taskEndDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.shifts != null) {
      data['shifts'] = this.shifts!.toJson();
    }
    return data;
  }
}

class Shifts {
  int? id;
  String? shiftName;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;

  Shifts(
      {this.id,
      this.shiftName,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.updatedAt});

  Shifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shiftName = json['shift_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shift_name'] = this.shiftName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


// import 'dart:io';

// import 'package:flutter/material.dart';

// class Tasksss {
//   int? id;
//   String? employeeId;
//   String? taskTitle;
//   String? taskDescription;
//   String? status;
//   String? taskDate;
//   String? shiftId;
//   Null? taskPoints;
//   Null? taskType;
//   Null? taskStartDate;
//   Null? taskEndDate;
//   String? createdAt;
//   String? updatedAt;
//   Shifts? shifts;

//   Tasksss(
//       {this.id,
//       this.employeeId,
//       this.taskTitle,
//       this.taskDescription,
//       this.status,
//       this.taskDate,
//       this.shiftId,
//       this.taskPoints,
//       this.taskType,
//       this.taskStartDate,
//       this.taskEndDate,
//       this.createdAt,
//       this.updatedAt,
//       this.shifts});

//   Tasksss.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     employeeId = json['employee_id'];
//     taskTitle = json['task_title'];
//     taskDescription = json['task_description'];
//     status = json['status'];
//     taskDate = json['task_date'];
//     shiftId = json['shift_id'];
//     taskPoints = json['task_points'];
//     taskType = json['task_type'];
//     taskStartDate = json['task_start_date'];
//     taskEndDate = json['task_end_date'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     shifts =
//         json['shifts'] != null ? new Shifts.fromJson(json['shifts']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['employee_id'] = this.employeeId;
//     data['task_title'] = this.taskTitle;
//     data['task_description'] = this.taskDescription;
//     data['status'] = this.status;
//     data['task_date'] = this.taskDate;
//     data['shift_id'] = this.shiftId;
//     data['task_points'] = this.taskPoints;
//     data['task_type'] = this.taskType;
//     data['task_start_date'] = this.taskStartDate;
//     data['task_end_date'] = this.taskEndDate;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.shifts != null) {
//       data['shifts'] = this.shifts!.toJson();
//     }
//     return data;
//   }
// }

// class Shifts {
//   int? id;
//   String? shiftName;
//   String? startTime;
//   String? endTime;
//   String? createdAt;
//   String? updatedAt;

//   Shifts(
//       {this.id,
//       this.shiftName,
//       this.startTime,
//       this.endTime,
//       this.createdAt,
//       this.updatedAt});

//   Shifts.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     shiftName = json['shift_name'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['shift_name'] = this.shiftName;
//     data['start_time'] = this.startTime;
//     data['end_time'] = this.endTime;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }