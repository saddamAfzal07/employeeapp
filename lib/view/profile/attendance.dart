import 'package:employeeapp/controller/profile_controller/profile_controller.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Attendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                          onTap: () => Get.to(()=> Notifications()),
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
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 9,
                      child: GetBuilder<ProfileController>(
                        init: ProfileController(),
                        builder: (controller) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.getAttendanceModel.length,
                            itemBuilder: (context, index) {
                              var data = controller.getAttendanceModel[index];
                              return AttendanceTiles(
                                msg: data.msg,
                                date: data.date,
                                description: data.description,
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
                        MyText(
                          text: '5',
                          size: 34,
                          color: kTertiaryColor,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
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
                              Center(
                                child: MyText(
                                  text: '2',
                                  color: kSecondaryColor,
                                  weight: FontWeight.w500,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
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
                              Center(
                                child: MyText(
                                  text: '3',
                                  color: kSecondaryColor,
                                  weight: FontWeight.w500,
                                  size: 36,
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
