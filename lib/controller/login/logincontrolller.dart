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

  RxString taskcount = ''.obs;
  RxString uncomplete = ''.obs;
  RxString complete = ''.obs;
  RxString pending = ''.obs;

  RxString yearpoints = ''.obs;
  RxString monthpoints = ''.obs;
  RxString previousmonthppoints = ''.obs;

  Loginwithdetails(String email, String password) async {
    print("-------iiiii");
    print(Api.baseurl);
    isdatasubmit.value = true;

    var response = await http.post(Uri.parse("${Api.baseurl}employeelogin"),
        body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      isdatasubmit.value = false;
      Map<String, dynamic> responsedata = jsonDecode(response.body);

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

  // void Tasks(
  //   DateTime date,
  //   String id,
  // ) async {
  //   // print(id);
  //   // print(date);
  //   // isdatasubmit.value = true;
  //   var token = Usererdatalist.usertoken;

  //   var url =
  //       "https://thepointsystemapp.com/employee/public/api/employee/dailyTask";

  //   var response = await http.post(Uri.parse(url), headers: {
  //     'Authorization': 'Bearer $token',
  //   }, body: {
  //     'date': date.toString(),
  //     'employee_id': id,
  //   });
  //   // print(id);
  //   // print(date);

  //   if (response.statusCode == 200) {
  //     showtasks.value = true;
  //     Map<String, dynamic> responsedata = jsonDecode(response.body);

  //     // print("check=>");
  //     print(responsedata);
  //     // print(responsedata["count"]);
  //     taskcount.value = responsedata["count"].toString();
  //     uncomplete.value = responsedata["unCompletedCount"].toString();
  //     complete.value = responsedata["completedCount"].toString();
  //     pending.value = responsedata["pedningApprovalCount"].toString();
  //   } else {}
  // }
  attendaceEmploye() async {
    print("startt");
    var token = Usererdatalist.usertoken;

    var url = "${Api.baseurl}current/year/points";

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    // print(response.body);
    Map<String, dynamic> responsedata = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responsedata["error"] == "No Points Found") {
        yearpoints.value = 0.toString();
        monthpoints.value = 0.toString();
        previousmonthppoints.value = 0.toString();
      } else {
        yearpoints.value = responsedata["this_year_count"].toString();
        monthpoints.value = responsedata["this_month_count"].toString();
        previousmonthppoints.value =
            responsedata["previous_month_count"].toString();
      }

      print("get response");

      // print("check=>");
      // print(responsedata);

    } else {
      yearpoints.value = 0.toString();
      monthpoints.value = 0.toString();
      previousmonthppoints.value = 0.toString();
      print("not response");
    }
  }

  employeTaskCount() async {
    print("taskcount");
    var token = Usererdatalist.usertoken;

    var url = "${Api.baseurl}task/counts";

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      // print("check=>");
      // print(responsedata);

      taskcount.value = responsedata["daily_task_count"].toString();
      uncomplete.value = responsedata["rejected_task_count"].toString();
      complete.value = responsedata["completed_task_count"].toString();
      pending.value = responsedata["pending_task_count"].toString();
    } else {
      print("not response");
    }
  }
}
