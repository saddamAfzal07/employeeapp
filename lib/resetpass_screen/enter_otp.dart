import 'dart:convert';

import 'package:employeeapp/resetpass_screen/confirm_password.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:http/http.dart' as http;

class Enterotp extends StatefulWidget {
  String email;
  Enterotp({Key? key, required this.email}) : super(key: key);

  @override
  State<Enterotp> createState() => _EnterotpState();
}

class _EnterotpState extends State<Enterotp> {
  String? id;
  bool isLoading = false;
  enterMail() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
        Uri.parse("https://thepointsystemapp.com/api/employee/verify/otp"),
        body: {'email': widget.email, 'otp': controller.text});

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      if (responsedata["msg"] == "OTP Un-Verified") {
        Get.snackbar(
          "OTP not verified",
          "",
          colorText: Colors.white,
          backgroundColor: Colors.grey,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
          borderWidth: 2,
        );
      } else {
        Map<String, dynamic> responsedata = jsonDecode(response.body);

        // Another method
        id = responsedata["data"]["id"].toString();
        print(id);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmPassword(
                      userid: id.toString(),
                    )));
      }
    } else {
      Get.snackbar(
        "OTP not verified",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  checkController() {
    if (controller.text.isNotEmpty) {
      enterMail();
    } else {
      Get.snackbar(
        "Enter 6 digits OTP",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          title: Text(
            " Enter OTP ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 250,
                    width: 300,
                    child: Image.asset("assets/images/enterotp.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinCodeTextField(
                        controller: controller,

                        highlightColor: Colors.blue,

                        maxLength: pinLength,
                        hasError: hasError,

                        onTextChanged: (text) {
                          setState(() {
                            hasError = false;
                          });
                        },
                        onDone: (text) {},
                        pinBoxWidth: 50,
                        pinBoxHeight: 64,
                        hasUnderline: true,
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 22.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        //                    pinBoxColor: Colors.green[100],
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                        // highlightAnimation: true,
                        // highlightAnimationBeginColor: Colors.black,
                        highlightAnimationEndColor: Colors.white12,
                        // keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              checkController();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Enter OTP",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                  )
                ]),
          ),
        ));
  }
}
