import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/profile/profile.dart';
import 'package:employeeapp/view/splash_screen/splash_screen.dart';
import 'package:employeeapp/view/widget/my_button.dart';
import 'package:employeeapp/view/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SharedPreferences? logindata;
  bool? newuser;

  @override
  void initState() {
    super.initState();
    // Login();
    // check();
    checkiflogin();
    // Login();
  }

  void check() async {
    var connectresult = await (Connectivity().checkConnectivity());
    if (connectresult == ConnectivityResult.none) {
      Get.snackbar(
        "Check Internet Connectivity",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    } else if (connectresult == ConnectivityResult.mobile) {
      Login();
    } else if (connectresult == ConnectivityResult.wifi) {
      Login();
    }
  }

  LoginController controller = Get.put(LoginController());
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  var labelColor;
  Login() {
    final isvalid = _formkey.currentState!.validate();
    if (isvalid) {
      controller.Loginwithdetails(emailcontroller.text, passcontroller.text);
      logindata!.setBool("login", false);
      logindata!.setString("username", emailcontroller.text);
      logindata!.setString("password", passcontroller.text);
      // logindata!.setString("password", passcontroller.text);
      // logindata!.setString("name", Usererdatalist.NAME);
      // logindata!.setString("fullname", Usererdatalist.F_NAME);
      // logindata!.setString("id", Usererdatalist.Id_no);

      // logindata!.setString("image1", Usererdatalist.image);

      // Get.offAll(() => Profile());
    } else {}
  }

  String? passvalidation(value) {
    if (value == null || value.isEmpty) {
      return "password is required";
    } else if (value.length < 5) {
      return "password must be  5 Characters";
    } else if (value.length > 15) {
      return "password is too Long";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  const Logo(),
                  Center(
                    child: Image.asset(
                      'assets/images/LOGIN.png',
                      height: 48,
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Email is required";
                        //   }
                        //   return null;
                        // },
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
                        controller: passcontroller,
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
                        validator: passvalidation,
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
                  // MyTextField(
                  //   labelText: 'Email',
                  //   hintText: 'example@companyname.com',
                  // ),
                  // MyTextField2(
                  //   labelText: 'Password',
                  //   hintText: '*****',
                  //   isObSecure: true,
                  // ),

                  Obx(
                    () => controller.isdatasubmit.value == false
                        ? MyButton(
                            onPressed: () {
                              // Login();
                              check();
                            },
                            text: 'Login',
                            textSize: 18,
                          )
                        : Center(child: CircularProgressIndicator()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  late SharedPreferences logindataa;
  late String usernamme;
  late String pass;

  void checkiflogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata!.getBool("login") ?? true);
    print(newuser);
    if (newuser == false) {
      logindataa = await SharedPreferences.getInstance();
      setState(() {
        usernamme = logindataa.getString("username")!;
        pass = logindataa.getString("password")!;

        // nameu = logindata.getString("name")!;
        // fullname = logindata.getString("fullname")!;
        // id = logindata.getString("id")!;
        // userimage = logindata.getString("image1")!;
      });
      controller.Loginwithdetails(usernamme, pass);

      // Get.offAll(() => Profile());
      // print(newuser);
    }
  }
}
