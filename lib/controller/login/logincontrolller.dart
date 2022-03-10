// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employeeapp/model/Loginmodel/loginmodel.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isdatasubmit = false.obs;
  var isdatareading = false.obs;
  var showtasks = false.obs;

  RxString taskcount = '...'.obs;
  RxString uncomplete = '...'.obs;
  RxString complete = '...'.obs;
  RxString pending = '...'.obs;

  Loginwithdetails(String email, String password) async {
    isdatasubmit.value = true;

    var response = await http.post(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employeelogin"),
        body: {'email': email, 'password': password});
    // print(response.body);
    if (response.statusCode == 200) {
      isdatasubmit.value = false;
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      // print("check=>");

      // Another method
      Usererdatalist.image = responsedata["emp_info"]["image"];
      Usererdatalist.NAME = responsedata["emp_info"]["first_name"];
      Usererdatalist.F_NAME = responsedata["emp_info"]["last_name"];
      Usererdatalist.EMAIL = responsedata["emp_info"]["email"];
      Usererdatalist.Id_no = responsedata["emp_info"]["identity_number"];
      Usererdatalist.CELL_NO = responsedata["emp_info"]["mobile_no"];
      Usererdatalist.usertoken = responsedata["token"];
      Usererdatalist.userid = responsedata["emp_info"]["id"].toString();

      Get.off(() => Profile());

      isdatareading.value = true;
    } else {
      isdatasubmit.value = false;

      Get.snackbar(
        "Login Failed",
        "Email or password is invalid",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  void Tasks(
    DateTime date,
    String id,
  ) async {
    // print(id);
    // print(date);
    // isdatasubmit.value = true;
    var token = Usererdatalist.usertoken;

    var url =
        "https://thepointsystemapp.com/employee/public/api/employee/dailyTask";

    var response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'date': date.toString(),
      'employee_id': id,
    });
    // print(id);
    // print(date);

    if (response.statusCode == 200) {
      showtasks.value = true;
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      // print("check=>");
      print(responsedata);
      // print(responsedata["count"]);
      taskcount.value = responsedata["count"].toString();
      uncomplete.value = responsedata["unCompletedCount"].toString();
      complete.value = responsedata["completedCount"].toString();
      pending.value = responsedata["pedningApprovalCount"].toString();
    } else {}
  }
}
