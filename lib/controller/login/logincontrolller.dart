// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/profile/profile.dart';
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

  loginwithdetails(String email, String password) async {
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
    }
  }

  attendaceEmploye() async {
    var token = Usererdatalist.usertoken;

    var url = "${Api.baseurl}current/year/points";

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

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
    } else {
      yearpoints.value = 0.toString();
      monthpoints.value = 0.toString();
      previousmonthppoints.value = 0.toString();
    }
  }

  employeTaskCount() async {
    var token = Usererdatalist.usertoken;

    var url = "${Api.baseurl}task/counts";

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      taskcount.value = responsedata["daily_task_count"].toString();
      uncomplete.value = responsedata["rejected_task_count"].toString();
      complete.value = responsedata["completed_task_count"].toString();
      pending.value = responsedata["pending_task_count"].toString();
    } else {}
  }
}
