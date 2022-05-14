class PreviousMonth {
  int? id;
  String? employeeId;
  String? taskAssignId;
  String? taskPoints;
  String? taskPointDescription;
  String? createdAt;
  String? updatedAt;
  TasksAssigin? tasksAssigin;

  PreviousMonth(
      {this.id,
      this.employeeId,
      this.taskAssignId,
      this.taskPoints,
      this.taskPointDescription,
      this.createdAt,
      this.updatedAt,
      this.tasksAssigin});

  PreviousMonth.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    taskAssignId = json['task_assign_id'];
    taskPoints = json['task_points'];
    taskPointDescription = json['task_point_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tasksAssigin = json['tasks_assigin'] != null
        ? new TasksAssigin.fromJson(json['tasks_assigin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['task_assign_id'] = this.taskAssignId;
    data['task_points'] = this.taskPoints;
    data['task_point_description'] = this.taskPointDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.tasksAssigin != null) {
      data['tasks_assigin'] = this.tasksAssigin!.toJson();
    }
    return data;
  }
}

class TasksAssigin {
  int? id;
  String? employeeId;
  String? image;
  String? taskId;
  String? shiftId;
  String? shiftDate;
  String? taskStatus;
  String? createdAt;
  String? updatedAt;
  TaskPoint? taskPoint;

  TasksAssigin(
      {this.id,
      this.employeeId,
      this.image,
      this.taskId,
      this.shiftId,
      this.shiftDate,
      this.taskStatus,
      this.createdAt,
      this.updatedAt,
      this.taskPoint});

  TasksAssigin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    image = json['image'];
    taskId = json['task_id'];
    shiftId = json['shift_id'];
    shiftDate = json['shift_date'];
    taskStatus = json['task_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taskPoint = json['task_point'] != null
        ? new TaskPoint.fromJson(json['task_point'])
        : null;
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
    if (this.taskPoint != null) {
      data['task_point'] = this.taskPoint!.toJson();
    }
    return data;
  }
}

class TaskPoint {
  int? id;
  String? taskTitle;
  String? taskDescription;
  String? createdAt;
  String? updatedAt;

  TaskPoint(
      {this.id,
      this.taskTitle,
      this.taskDescription,
      this.createdAt,
      this.updatedAt});

  TaskPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTitle = json['task_title'];
    taskDescription = json['task_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_title'] = this.taskTitle;
    data['task_description'] = this.taskDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
