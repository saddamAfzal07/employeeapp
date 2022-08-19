import 'dart:async';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Get.off(() => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Logo(),
          Image.asset(
            'assets/images/Employee App.png',
            height: 96,
          )
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: 73,
        height: 73,
        decoration: BoxDecoration(
          gradient: blueGradientEffectCircle,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/Vector (3).png',
              height: 30,
            ),
          ),
        ),
      ),
    );
  }
}
