// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:ffi';

import 'dart:io';

import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/controller/profile_controller/profile_controller.dart';
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

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    taskcall();

    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => checkForNewSharedLists());
  }

  void checkForNewSharedLists() {
    // do request here
    setState(() {
      taskcall();
    });
  }

  LoginController controller = Get.put(LoginController());

  taskcall() async {
    controller.Tasks(now, id);
  }

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
                        child: Image.network(
                          "https://thepointsystemapp.com/employee/public/" +
                              Usererdatalist.image,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
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
                          text: '2',
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
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            child: MyText(
                              paddingLeft: 20.0,
                              paddingBottom: 15.0,
                              text: 'Daily Uniform Check',
                              size: 18,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // check

                    Expanded(flex: 2, child: checkimage()),

                    // check

                    Expanded(
                      flex: 9,
                      child: GetBuilder<ProfileController>(
                        init: ProfileController(),
                        builder: (controller) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.getProfileModel.length,
                            itemBuilder: (context, index) {
                              var data = controller.getProfileModel[index];
                              return ProfileTiles(
                                date: data.date,
                                status: data.status,
                                verified: data.verified,
                                notVerified: data.notVerified,
                                warning: data.warning,
                              );
                            },
                          );
                        },
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
                              MyText(
                                text: '5',
                                color: kTertiaryColor,
                                weight: FontWeight.w500,
                                size: 36,
                              ),
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
                                // DONE?
                                //G bhai Ok Take care bro!

                                Obx(() {
                                  return loginCotroller.showtasks.value
                                      ? Text(
                                          loginCotroller.taskcount.value
                                              .toString(),
                                          style: TextStyle(fontSize: 34),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            "Please wait",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        );
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
