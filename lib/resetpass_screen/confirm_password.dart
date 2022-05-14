import 'dart:convert';

import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/user/login.dart';
import 'package:employeeapp/view/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ConfirmPassword extends StatefulWidget {
  String userid;
  ConfirmPassword({Key? key, required this.userid}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  bool isLoaading = false;

  resetpass() async {
    setState(() {
      isLoaading = true;
    });
    var response = await http.post(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/password/update"),
        body: {
          'user_id': widget.userid,
          'password': password.text,
        });
    if (response.statusCode == 200) {
      setState(() {
        isLoaading = false;
      });
      Get.snackbar(
        "Password Successfully Reset",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );

      Map<String, dynamic> responsedata = jsonDecode(response.body);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
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

  passcheck() {
    print(" check");
    final isvalid = _formkey.currentState!.validate();
    if (isvalid && password.text == confirmpass.text) {
      resetpass();
    } else {
      print("not match");
      Get.snackbar(
        "Password & Confirm Password must be same",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  // String? passvalidation(value) {
  //   if (value == null || value.isEmpty) {
  //     return "password is required";
  //   } else if (value.length > 15) {
  //     return "password is too Long";
  //   } else {
  //     return null;
  //   }
  // }

  var labelColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        title: Text(
          "Set Password",
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
                    child: Image.asset("assets/images/password.png"),
                  ),
                  Text(
                    "Enter  Password ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kSecondaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ///////////////
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
                        controller: password,
                        obscureText: true,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Password is required";
                        //   }
                        //   return null;
                        // },
                        // validator: MultiValidator([
                        //   MinLengthValidator(6,
                        //       errorText: "Password must be 6 characters")
                        // ]),
                        validator: RequiredValidator(
                            errorText: 'Password is required'),
                        onTap: () {},
                        cursorColor: kGreyColor,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: kBlackColor.withOpacity(0.6),
                        ),
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: labelColor,
                          ),
                          hintText: '*******',
                          hintStyle: TextStyle(
                            fontSize: 14,
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

                  Text(
                    "Confirm Password ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kSecondaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ///////////////
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
                        controller: confirmpass,
                        obscureText: true,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Password is required";
                        //   }
                        //   return null;
                        // },
                        // validator: MultiValidator([
                        //   MinLengthValidator(6,
                        //       errorText: "Password must be 6 characters")
                        // ]),
                        validator: RequiredValidator(
                            errorText: 'Password is required'),
                        onTap: () {},
                        cursorColor: kGreyColor,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: kBlackColor.withOpacity(0.6),
                        ),
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: labelColor,
                          ),
                          hintText: '*******',
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

                  isLoaading
                      ? CircularProgressIndicator()
                      : MyButton(
                          onPressed: () {
                            passcheck();
                          },
                          text: 'Reset Password',
                          textSize: 18,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
