class Notifi {
  int? id;
  String? employeeId;
  String? notificationText;
  String? markAsRead;
  String? createdAt;
  String? updatedAt;
  String? conColor;

  Notifi(
      {this.id,
      this.employeeId,
      this.notificationText,
      this.markAsRead,
      this.createdAt,
      this.updatedAt,
      this.conColor});

  Notifi.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    notificationText = json['notification_text'];
    markAsRead = json['mark_as_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    conColor = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['notification_text'] = this.notificationText;
    data['mark_as_read'] = this.markAsRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
