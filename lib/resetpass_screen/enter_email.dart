import 'dart:convert';

import 'package:employeeapp/resetpass_screen/enter_otp.dart';
import 'package:flutter/material.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_button.dart';

import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class EnterEmail extends StatefulWidget {
  const EnterEmail({Key? key}) : super(key: key);

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  bool isloading = true;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  var labelColor;
  String? email;

  enterMail() async {
    var response = await http.post(
        Uri.parse("https://thepointsystemapp.com/api/employee/email/verify"),
        body: {
          'email': emailcontroller.text,
        });
    if (response.statusCode == 200) {
      setState(() {
        isloading = true;
      });
      print(isloading);
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      // Another method
      email = responsedata["data"]["email"];

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Enterotp(
                    email: email.toString(),
                  )));
    } else {
      setState(() {
        bool isloading = true;
      });
      Get.snackbar(
        "Try Again",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  sendOtp() {
    final isvalid = _formkey.currentState!.validate();
    if (isvalid) {
      setState(() {
        bool isloading = false;
        print(isloading);
      });
      enterMail();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        title: Text(
          " Reset Password ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formkey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 300,
                    child: Image.asset("assets/images/emailsent.png"),
                  ),
                  Text(
                    "Enter e-mail to Reset Password ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kSecondaryColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          labelColor = hasFocus
                              ? kSecondaryColor
                              : kBlackColor.withOpacity(0.6);
                        });
                      },
                      child: TextFormField(
                        controller: emailcontroller,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Email is required"),
                            EmailValidator(errorText: "Not a valid Email"),
                          ],
                        ),
                        onTap: () {},
                        cursorColor: kGreyColor,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: kBlackColor.withOpacity(0.6),
                        ),
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: labelColor,
                          ),
                          hintText: 'example@companyname.com',
                          prefixIcon: Icon(Icons.email),
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: kBlackColor.withOpacity(0.6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 23),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: kInputBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: kInputBorderColor,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: kSecondaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///////////////

                  isloading
                      ? MyButton(
                          onPressed: () {
                            sendOtp();
                          },
                          text: 'Send  OTP',
                          textSize: 18,
                        )
                      : Center(
                          child: CircularProgressIndicator(
                          color: Colors.blue,
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
