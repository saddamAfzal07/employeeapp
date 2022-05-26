import 'dart:convert';
import 'dart:math';

import 'package:employeeapp/controller/notifications/notification_controller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_app_bar.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/notifications_model/notifications_model.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isloadingwaiting = false;
  var token = Usererdatalist.usertoken;

  List<Notifi> notification = [];
  bool notext = false;
  fetchapi() async {
    setState(() {
      isloadingwaiting = true;
    });
    // setState(() {
    //   var date = selecteddate.toString().substring(
    //                               0, selecteddate.length, 10)),

    // });
    var response = await http.get(
      Uri.parse(
          "https://thepointsystemapp.com/employee/public/api/all/notifications"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    Map data = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      if (data["notifications"].isEmpty) {
        if (mounted) {
          setState(() {
            isloadingwaiting = false;
            notext = true;
          });
        }
      } else {
        for (int i = 0; i < data["notifications"].length; i++) {
          Map obj = data["notifications"][i];
          Notifi pos = Notifi();

          pos = Notifi.fromJson(obj);
          notification.add(pos);
        }
      }

      setState(() {
        isloadingwaiting = false;
      });

      // shift();

    } else {
      setState(() {
        isloadingwaiting = false;
      });
    }
  }

  @override
  void initState() {
    // fetchapi();
    controller.fetchapi();
    super.initState();
  }

  notificationUpload(String id) async {
    final bodyy = {
      'notification_id': id,
    };

    http.Response response = await http.post(
      Uri.parse(
          "https://thepointsystemapp.com/employee/public/api/mark/specific/notification/as/read"),
      body: jsonEncode(bodyy),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    // var data = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print("updated response");
    } else {}
  }

  NotificationController controller = Get.put(NotificationController());

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
      body: isloadingwaiting
          ? Center(
              child: CircularProgressIndicator(
                color: kSecondaryColor,
              ),
            )
          :

          //   Obx(
          // () =>
          ListView.builder(
              itemCount: controller.notification.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    notificationUpload(notification[index].id.toString());
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: notification[index].markAsRead == "1"
                                ? kGreenColor
                                : kSecondaryColor),
                      ),
                      child: ListTile(
                        minVerticalPadding: 20,
                        minLeadingWidth: 30,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(controller
                              .notification[index].notificationText
                              .toString()),
                        ),
                        subtitle: Text(
                          notification[index].createdAt.toString().substring(0,
                              min(notification[index].createdAt!.length, 10)),
                        ),
                      )),
                );
              })),
      // )
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
