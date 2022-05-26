import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/controller/profile_controller/profile_controller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/model/points/month.dart';
import 'package:employeeapp/model/points/previous.dart';
import 'package:employeeapp/model/points/yearly_points.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Attendance extends StatefulWidget {
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isloadingcomplete = true;
  bool notext = false;
  List<ThisYear> yearlyPoints = [];
  yearlyPointsApi() async {
    var token = Usererdatalist.usertoken;
    setState(() {
      isloadingcomplete = true;
    });

    var response = await http
        .get(Uri.parse("${Api.baseurl}current/year/points"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["error"] == "No Points Found") {
        setState(() {
          notext = true;
        });
      } else {
        print("Compeleted Task Found");
        // setState(() {
        //   notext = false;
        // });

        for (int i = 0; i < data["this_year"].length; i++) {
          Map obj = data["this_year"][i];
          ThisYear pos = ThisYear();
          pos = ThisYear.fromJson(obj);
          yearlyPoints.add(pos);
        }
      }
      setState(() {
        isloadingcomplete = false;
      });
    } else {
      setState(() {
        isloadingcomplete = false;
      });
    }
  }

  bool isloadingmonth = true;
  bool notextmonth = false;
  List<ThisMonth> monthlyPoints = [];
  monthlyPointsApi() async {
    var token = Usererdatalist.usertoken;
    setState(() {
      isloadingmonth = true;
    });

    var response = await http
        .get(Uri.parse("${Api.baseurl}current/month/points"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["error"] == "No Points Found") {
        print("No Compeleted Task Found");
        setState(() {
          notextmonth = true;
        });
      } else {
        print("Compeleted Task Found");
        // setState(() {
        //   notext = false;
        // });

        for (int i = 0; i < data["this_month"].length; i++) {
          Map obj = data["this_month"][i];
          ThisMonth pos = ThisMonth();
          pos = ThisMonth.fromJson(obj);
          monthlyPoints.add(pos);
        }
      }
      setState(() {
        isloadingmonth = false;
      });
    } else {
      setState(() {
        isloadingmonth = false;
      });
    }
  }

  bool isloadinpreviousgmonth = true;
  bool notextpreviousmonth = false;
  List<PreviousMonth> previousmonthlyPoints = [];
  previousPointsApi() async {
    var token = Usererdatalist.usertoken;
    setState(() {
      isloadinpreviousgmonth = true;
    });

    var response = await http
        .get(Uri.parse("${Api.baseurl}previous/month/points"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["error"] == "No Points Found") {
        print("No Compeleted Task Found");
        setState(() {
          notextpreviousmonth = true;
        });
      } else {
        print("Compeleted Task Found");
        // setState(() {
        //   notext = false;
        // });

        for (int i = 0; i < data["previous_month"].length; i++) {
          Map obj = data["previous_month"][i];
          PreviousMonth pos = PreviousMonth();
          pos = PreviousMonth.fromJson(obj);
          previousmonthlyPoints.add(pos);
        }
      }
      setState(() {
        isloadinpreviousgmonth = false;
      });
    } else {
      setState(() {
        isloadinpreviousgmonth = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yearlyPointsApi();
  }

  bool yearly = true;
  bool monthly = false;
  bool previousmonthly = false;

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
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 50),
                  decoration: BoxDecoration(
                    gradient: orangeGradientEffect,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                      icon: Image.asset(
                        'assets/images/Vector (11).png',
                        height: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                    title: MyText(
                      text: 'Points',
                      size: 20,
                      color: kPrimaryColor,
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
              Visibility(
                visible: yearly,
                child: Expanded(
                  flex: 9,
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                      Expanded(
                          flex: 8,
                          child: isloadingcomplete
                              ? Center(child: CircularProgressIndicator())
                              : notext
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 200),
                                      child: Text("Not Any Points Available"),
                                    )
                                  : ListView.builder(
                                      itemCount: yearlyPoints.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border: Border.all(
                                              color: kTertiaryColor,
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15),
                                            isThreeLine: true,
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/Vector (9).png',
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text:
                                                      "Uncompleted Task +${yearlyPoints[index].taskPoints} Point",
                                                  size: 16,
                                                  weight: FontWeight.w700,
                                                  color: kTertiaryColor,
                                                ),
                                                MyText(
                                                  paddingTop: 7,
                                                  paddingBottom: 7,
                                                  text: yearlyPoints[index]
                                                      .createdAt,
                                                  size: 14,
                                                  color: kGreyColor,
                                                ),
                                              ],
                                            ),
                                            subtitle: MyText(
                                              text: yearlyPoints[index]
                                                  .taskPointDescription,
                                              size: 14,
                                            ),
                                          ),
                                        );
                                      })),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: monthly,
                child: Expanded(
                  flex: 9,
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                      Expanded(
                          flex: 8,
                          child: isloadingmonth
                              ? Center(child: CircularProgressIndicator())
                              : notextmonth
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 200),
                                      child: Text("Not Any Points Available"),
                                    )
                                  : ListView.builder(
                                      itemCount: monthlyPoints.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border: Border.all(
                                              color: kTertiaryColor,
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15),
                                            isThreeLine: true,
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/Vector (9).png',
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text:
                                                      "Uncompleted Task +${monthlyPoints[index].taskPoints} Point",
                                                  size: 16,
                                                  weight: FontWeight.w700,
                                                  color: kTertiaryColor,
                                                ),
                                                MyText(
                                                  paddingTop: 7,
                                                  paddingBottom: 7,
                                                  text: monthlyPoints[index]
                                                      .createdAt,
                                                  size: 14,
                                                  color: kGreyColor,
                                                ),
                                              ],
                                            ),
                                            subtitle: MyText(
                                              text: monthlyPoints[index]
                                                  .taskPointDescription,
                                              size: 14,
                                            ),
                                          ),
                                        );
                                      })),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: previousmonthly,
                child: Expanded(
                  flex: 9,
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                      Expanded(
                          flex: 8,
                          child: isloadinpreviousgmonth
                              ? Center(child: CircularProgressIndicator())
                              : notextpreviousmonth
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 200),
                                      child: Text("Not Any Points Available"),
                                    )
                                  : ListView.builder(
                                      itemCount: previousmonthlyPoints.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border: Border.all(
                                              color: kTertiaryColor,
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15),
                                            isThreeLine: true,
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/Vector (9).png',
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text:
                                                      "Uncompleted Task +${previousmonthlyPoints[index].taskPoints} Point",
                                                  size: 16,
                                                  weight: FontWeight.w700,
                                                  color: kTertiaryColor,
                                                ),
                                                MyText(
                                                  paddingTop: 7,
                                                  paddingBottom: 7,
                                                  text: previousmonthlyPoints[
                                                          index]
                                                      .createdAt,
                                                  size: 14,
                                                  color: kGreyColor,
                                                ),
                                              ],
                                            ),
                                            subtitle: MyText(
                                              text: previousmonthlyPoints[index]
                                                  .taskPointDescription,
                                              size: 14,
                                            ),
                                          ),
                                        );
                                      })),
                    ],
                  ),
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
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: 'Total Points',
                          size: 20,
                          color: kTertiaryColor,
                          weight: FontWeight.w500,
                        ),
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                yearly = true;
                                monthly = false;
                                previousmonthly = false;
                              });
                              yearlyPointsApi();
                            },
                            child: Text(
                              loginCotroller.yearpoints.value.toString(),
                              style: TextStyle(
                                color: kTertiaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 36,
                              ),
                            ),
                          );
                        }),
                        // MyText(
                        //   text: '5',
                        //   size: 34,
                        //   color: kTertiaryColor,
                        //   weight: FontWeight.w500,
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                yearly = false;
                                monthly = false;
                                previousmonthly = true;
                              });
                              previousPointsApi();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: MyText(
                                    text: 'Last Month',
                                    color: kSecondaryColor,
                                    weight: FontWeight.w500,
                                    size: 18,
                                  ),
                                ),
                                Obx(() {
                                  return Center(
                                    child: Text(
                                      loginCotroller.previousmonthppoints.value
                                          .toString(),
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 36,
                                      ),
                                    ),
                                  );
                                }),
                                // Center(
                                //   child: MyText(
                                //     text: '2',
                                //     color: kSecondaryColor,
                                //     weight: FontWeight.w500,
                                //     size: 36,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                yearly = false;
                                monthly = true;
                                previousmonthly = false;
                              });
                              monthlyPointsApi();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: MyText(
                                    text: 'This Month',
                                    color: kSecondaryColor,
                                    weight: FontWeight.w500,
                                    size: 18,
                                  ),
                                ),
                                Obx(() {
                                  return Center(
                                    child: Text(
                                      loginCotroller.monthpoints.value
                                          .toString(),
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 36,
                                      ),
                                    ),
                                  );
                                }),
                                // Center(
                                //   child: MyText(
                                //     text: '3',
                                //     color: kSecondaryColor,
                                //     weight: FontWeight.w500,
                                //     size: 36,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class AttendanceTiles extends StatelessWidget {
  var msg, date, description;

  AttendanceTiles({
    this.msg,
    this.date,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: kTertiaryColor,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        isThreeLine: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/Vector (9).png',
              height: 20,
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: '$msg',
              size: 16,
              weight: FontWeight.w700,
              color: kTertiaryColor,
            ),
            MyText(
              paddingTop: 7,
              paddingBottom: 7,
              text: '$date',
              size: 14,
              color: kGreyColor,
            ),
          ],
        ),
        subtitle: MyText(
          text: '$description',
          size: 14,
        ),
      ),
    );
  }
}
