import 'package:employeeapp/view/camera/camera.dart';
import 'package:employeeapp/view/camera/daily_verify.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/profile/attendance.dart';
import 'package:employeeapp/view/profile/profile.dart';
import 'package:employeeapp/view/splash_screen/splash_screen.dart';
import 'package:employeeapp/view/tasks/tasks.dart';
import 'package:employeeapp/view/user/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/persondetail/persondetail.dart';

void main() => runApp(EmployeeApp());

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Employee App',
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        accentColor: kSecondaryColor.withOpacity(0.1),
        fontFamily: 'Sf Pro Display',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/splash_screen',
      getPages: [
        GetPage(name: '/splash_screen', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/attendance', page: () => Attendance()),
        GetPage(name: '/daily_verify', page: () => DailyVerify()),
        GetPage(name: '/camera', page: () => Camera()),
        GetPage(name: '/notifications', page: () => Notifications()),
        GetPage(name: '/tasks', page: () => Tasks()),
        GetPage(name: '/pdetail', page: () => Personaldetail()),
      ],
    );
  }
}
