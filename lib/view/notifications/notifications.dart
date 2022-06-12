import 'dart:convert';
import 'dart:math';

import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/profile/profile.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
      marktext = false;
    });
    notification = [];
    setState(() {
      isloadingwaiting = true;
    });
    // setState(() {
    //   var date = selecteddate.toString().substring(
    //                               0, selecteddate.length, 10)),

    // });
    var response = await http.get(
      Uri.parse("${Api.baseurl}all/notifications"),
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


    } else {
      setState(() {
        isloadingwaiting = false;
      });
    }
  }

  bool marktext = false;
  markAllRead() async {
    setState(() {
      marktext = true;
    });
    var response = await http.get(
      Uri.parse("${Api.baseurl}mark/all/notifications/as/read"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    Map data = jsonDecode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      fetchapi();
    } else {}
  }

  @override
  void initState() {
    fetchapi();
    // controller.fetchapi();
    super.initState();
  }

  notificationUpload(String id) async {
    final bodyy = {
      'notification_id': id,
    };

    http.Response response = await http.post(
      Uri.parse("${Api.baseurl}mark/specific/notification/as/read"),
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

  String noti = "change";

  int? currentindex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Profile())),
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
          ],
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    markAllRead();
                  },
                  child: MyText(
                    text: "Mark All",
                    size: 16,
                    color: marktext ? kGreyColor : kSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: isloadingwaiting
          ? Center(
              child: CircularProgressIndicator(
                color: kSecondaryColor,
              ),
            )
          : ListView.builder(
            
              itemCount: notification.length,
              itemBuilder: ((context, index) {
                var date = DateFormat("dd-MM-yyyy").format(
                    DateTime.parse(notification[index].createdAt.toString()));

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      notification[index].conColor = noti;
                    });

                    notificationUpload(notification[index].id.toString());
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: notification[index].conColor == "change"
                                ? kGreyColor
                                : notification[index].markAsRead == "1"
                                    ? kGreyColor
                                    : kSecondaryColor),
                      ),
                      child: ListTile(
                        minVerticalPadding: 20,
                        minLeadingWidth: 30,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                              notification[index].notificationText.toString()),
                        ),
                        subtitle: Text(
                          date.substring(0, min(date.length, 10)),
                        ),
                        trailing: notification[index].conColor == "change"
                            ? Image.asset(
                                'assets/images/Vector (8).png',
                                height: 24,
                                width: 24,
                              )
                            : notification[index].markAsRead == "1"
                                ? Image.asset(
                                    'assets/images/Vector (8).png',
                                    height: 24,
                                    width: 24,
                                  )
                                : Text(""),
                      )),
                );
              })),
      // )
    );
  }
}
