import 'dart:convert';

import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/model/notifications_model/notifications_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  bool isloadingwaiting = false;
  var token = Usererdatalist.usertoken;

  RxList notification = [].obs;
  bool notext = false;
  fetchapi() async {
    print("start fetch");
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
        // if (mounted) {
        //   setState(() {
        //     isloadingwaiting = false;
        //     notext = true;
        //   });
      }
    } else {
      for (int i = 0; i < data["notifications"].length; i++) {
        Map obj = data["notifications"][i];
        Notifi pos = Notifi();

        pos = Notifi.fromJson(obj);
        notification.add(pos);
      }
    }

    // setState(() {
    //   isloadingwaiting = false;
    // });

    // shift();
  }
}
