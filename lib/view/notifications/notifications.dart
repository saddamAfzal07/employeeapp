import 'package:employeeapp/controller/notifications_controller/notifications_controller.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_app_bar.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Image.asset(
            'assets/images/Vector (11).png',
            height: 18,
            color: kSecondaryColor,
          ),
        ),
        title: Row(
          children: [
            MyText(
              text: "Notifications",
              size: 18,
              color: kSecondaryColor,
              weight: FontWeight.w500,
            ),
            const SizedBox(
              width: 10,
            ),
            MyText(
              text: "2",
              size: 20,
              color: kSecondaryColor,
              weight: FontWeight.w700,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: GetBuilder<NotificationsController>(
          init: NotificationsController(),
          builder: (controller) {
            return ListView.builder(
              itemCount: controller.getNotifications.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, index) {
                var data = controller.getNotifications[index];
                return NotificationsTiles(
                  notifyText: data.notifyText,
                  time: data.time,
                  warning: data.warning,
                );
              },
            );
          }),
    );
  }
}

class NotificationsTiles extends StatelessWidget {
  bool? warning;
  var notifyText, time;

  NotificationsTiles({
    this.notifyText,
    this.time,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: warning == true ? kTertiaryColor : kInputBorderColor,
        ),
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              warning == true
                  ? 'assets/images/Vector (9).png'
                  : 'assets/images/Vector (10).png',
              height: 20,
            ),
          ],
        ),
        title: MyText(
          text: '$notifyText',
          size: 14,
        ),
        subtitle: MyText(
          text: '$time',
          size: 14,
          color: kBlackColor.withOpacity(0.6),
        ),
      ),
    );
  }
}
