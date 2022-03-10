import 'package:employeeapp/model/notifications_model/notifications_model.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  List<NotificationsModel> notifications = [
    NotificationsModel(
      notifyText:
          'You recivied 1 Points for missing verify for daily attendance.',
      time: '06.05.2021',
      warning: true,
    ),
    NotificationsModel(
      notifyText: 'Your daily tasks updated.',
      time: '05.05.2021',
    ),
    NotificationsModel(
      notifyText: 'You recivied 1 Points for not completing task - “Task Name”',
      time: '04.05.2021',
      warning: true,
    ),
    NotificationsModel(
      notifyText: 'Your daily tasks updated.',
      time: '05.05.2021',
    ),
    NotificationsModel(
      notifyText: 'Your daily tasks updated.',
      time: '05.05.2021',
    ),
    NotificationsModel(
      notifyText: 'Your daily tasks updated.',
      time: '05.05.2021',
    ),
  ];

  List<NotificationsModel> get getNotifications => notifications;
}
