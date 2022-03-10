
class NotificationsModel{
  bool? warning;
  var notifyText, time;

  NotificationsModel({
    this.notifyText,
    this.time,
    this.warning = false,
  });
}