class RejectedTasks {
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

  RejectedTasks(
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
      this.updatedAt});

  RejectedTasks.fromJson(Map<dynamic, dynamic> json) {
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
    return data;
  }
}
