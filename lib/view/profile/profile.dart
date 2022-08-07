// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:ffi';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:employeeapp/controller/login/logincontrolller.dart';

import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';

import 'package:employeeapp/view/camera/camera.dart';
import 'package:employeeapp/view/camera/daily_verify.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/profile/attendance.dart';
import 'package:employeeapp/view/profile/profilrtile.dart';
import 'package:employeeapp/view/tasks/tasks.dart';
import 'package:employeeapp/view/tasks/tasks.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Action;

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Timer? timer;

  attendanceCall() {
    controller.attendaceEmploye();
    controller.employeTaskCount();
    notificationCount();
    print("==>");
    print(controller.yearpoints);
  }

  LoginController controller = Get.put(LoginController());

  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var name = Usererdatalist.NAME;

  var fname = Usererdatalist.F_NAME;
  var id = Usererdatalist.userid;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String? tokensignal;
  Future<void> initPlatform() async {
    print("enter");
    await OneSignal.shared.setAppId("671b3c95-34db-4eef-b71d-b2fe54dc8edc");
    await OneSignal.shared.getDeviceState().then((value) => {
          print("userid==>"),
          print(value!.userId),
          setState(() {
            tokensignal = value.userId;
          }),
          print("====>${tokensignal}"),
        });
    oneSignalToken();
  }

  oneSignalToken() async {
    print("startt fun");
    var token = Usererdatalist.usertoken;

    var response = await http.post(
      Uri.parse("${Api.baseurl}one/signal/token/save"),
      body: {'email': Usererdatalist.EMAIL, 'token': tokensignal},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("token");
      print(" response 200");
    } else {
      print("not response");
    }
  }

  String notification = "";
  notificationCount() async {
    print("taskcount");
    var token = Usererdatalist.usertoken;

    var url = "${Api.baseurl}main/task/counts";

    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      setState(() {
        notification = responsedata["unread_notification_count"].toString();
      });

      print("not response");
    }
  }

  bool submit = false;
  var token = Usererdatalist.usertoken;
  checkDailyuniform() async {
    var response =
        await http.get(Uri.parse("${Api.baseurl}uniform/check/task"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["show_uniform_check"] == true &&
          data["uniform_check_submitted"] == false) {
        getimage();
      } else {
        if (data["uniform_check_submitted"] == true) {
          print("get attendance");
          Get.snackbar(
            "You have already submitted your daily uniform check.",
            "",
            colorText: Colors.white,
            backgroundColor: Colors.yellow.shade700,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 10,
            borderWidth: 2,
          );
        }
        if (data["no_daily_task_exsist"] == true) {
          Get.snackbar(
            "Can't Submit",
            "Because there is not any task available for today.",
            colorText: Colors.white,
            backgroundColor: Colors.red.shade600,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 10,
            borderWidth: 2,
          );
        }
      }
    } else {
      Get.snackbar(
        "Something went wrong.",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  File? image;
  bool isimagepick = false;

  final _picker = ImagePicker();
  Future getimage() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
        isimagepick = true;
        submit = true;
      });
    } else {
      print("Not any image is selected");
    }
  }

  bool isLoadSubmit = false;
  bool imagesubmit = false;
  submitUniform() async {
    setState(() {
      isLoadSubmit = true;
    });
    var token = Usererdatalist.usertoken;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unnecessary_new
    final multipartRequest = new http.MultipartRequest(
        "POST", Uri.parse("${Api.baseurl}employee/uniformCheck"));
    multipartRequest.headers.addAll(headers);

    multipartRequest.fields.addAll({});

    multipartRequest.files.add(await http.MultipartFile.fromPath(
      'image',
      image!.path,
    ));
    http.StreamedResponse response = await multipartRequest.send();

    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      setState(() {
        isLoadSubmit = false;
        image = null;
        submit = false;
        imagesubmit = true;
      });
      print("Done");

      Get.snackbar(
        "Submit Successfully",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );

      print(responseString);
    } else {
      setState(() {
        isLoadSubmit = false;
        image == null;
        submit = false;
      });
      Get.snackbar(
        "Something went wrong",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  @override
  void initState() {
    print("0000000000");
    print("back");
    super.initState();
    controller.attendaceEmploye();
    controller.employeTaskCount();
    notificationCount();
    attendanceCall();

    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => controller.employeTaskCount());
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginCotroller = Get.find();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  decoration: BoxDecoration(
                    gradient: blueGradientEffect,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: GestureDetector(
                      onTap: () {
                        Get.toNamed('/pdetail');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: "https://thepointsystemapp.com/" +
                              Usererdatalist.image,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/user.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/user.png"),
                        ),

                        //     Image.network(
                        //   "https://thepointsystemapp.com/" +
                        //       Usererdatalist.image,
                        //   height: 45,
                        //   width: 45,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    title: MyText(
                      text: name + " $fname",
                      color: kPrimaryColor,
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                    trailing: Wrap(
                      spacing: 12.0,
                      children: [
                        MyText(
                          text: notification,
                          size: 18,
                          weight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => Notifications()),
                          child: Image.asset(
                            'assets/images/Vector (4).png',
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: GestureDetector(
                              child: MyText(
                                paddingLeft: 20.0,
                                paddingBottom: 15.0,
                                text: 'Daily Uniform Check',
                                size: 18,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: kGreenColor),
                            ),
                            child: ListTile(
                                minVerticalPadding: 20,
                                minLeadingWidth: 30,
                                leading: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: image == null
                                      ? Image.asset(
                                          "assets/images/pic.png",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(image!.path).absolute,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                title: Text(
                                  "Submit Your uniform check",
                                ),
                                trailing: imagesubmit
                                    ? Image.asset(
                                        "assets/images/Vector (8).png",
                                        height: 20,
                                      )
                                    : isLoadSubmit
                                        ? Container(
                                            child: CircularProgressIndicator(
                                            color: kSecondaryColor,
                                          ))
                                        : submit
                                            ? GestureDetector(
                                                onTap: () {
                                                  print("click submit");
                                                  submitUniform();
                                                },
                                                child: Icon(
                                                  Icons.send,
                                                  color: kSecondaryColor,
                                                ))
                                            : GestureDetector(
                                                onTap: () {
                                                  checkDailyuniform();
                                                },
                                                child: Image.asset(
                                                  'assets/images/Vector (7).png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              )
                                // : TextButton(
                                //     onPressed: () {
                                //       // uploadImage(index);
                                //     },
                                //     child: Text("Submit"),
                                //   ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Card(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 115,
            ),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 163,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => Attendance());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/Vector (5).png',
                            height: 20,
                          ),
                          Center(
                            child: MyText(
                              text: 'Total Yearly Points',
                              color: kTertiaryColor,
                              weight: FontWeight.w500,
                              size: 18,
                              maxlines: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                return
                                    //  loginCotroller.yearpoints.value.isBool
                                    //     ?
                                    Text(
                                  loginCotroller.yearpoints.value.toString(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: kTertiaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                                // : Center(
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(12),
                                //       child: CircularProgressIndicator(),

                                //       //  Text(
                                //       //   "Please wait",
                                //       //   style: TextStyle(fontSize: 18),
                                //       // ),
                                //     ),
                                //   );
                              }),
                              // MyText(
                              //   text: '5',
                              //   color: kTertiaryColor,
                              //   weight: FontWeight.w500,
                              //   size: 36,
                              // ),
                              const SizedBox(
                                width: 20,
                              ),
                              RotatedBox(
                                quarterTurns: 2,
                                child: Image.asset(
                                  'assets/images/Vector (11).png',
                                  height: 12,
                                  color: kGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      // hoverColor: Colors.blue,
                      onTap: () => Get.to(() => Tasks()),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/images/Vector (6).png',
                              height: 20,
                            ),
                            Center(
                              child: MyText(
                                text: 'Today’s Tasks',
                                color: kBlackColor,
                                weight: FontWeight.w500,
                                maxlines: 1,
                                overFlow: TextOverflow.ellipsis,
                                size: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return Text(
                                      loginCotroller.taskcount.value.toString(),
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 34));
                                }),
                                const SizedBox(
                                  width: 20,
                                ),
                                RotatedBox(
                                  quarterTurns: 2,
                                  child: Image.asset(
                                    'assets/images/Vector (11).png',
                                    height: 12,
                                    color: kGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor.withOpacity(0.2),
                    kPrimaryColor,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
