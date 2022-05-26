import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/user/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personaldetail extends StatefulWidget {
  Personaldetail({Key? key}) : super(key: key);

  @override
  State<Personaldetail> createState() => _PersonaldetailState();
}

class _PersonaldetailState extends State<Personaldetail> {
  late SharedPreferences logindata;
  late String usernamme;
  // late String nameu;
  // late String fullname;
  // late String id;
  // late String userimage;

  void initstate() {
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      usernamme = logindata.getString("username")!;

      // nameu = logindata.getString("name")!;
      // fullname = logindata.getString("fullname")!;
      // id = logindata.getString("id")!;
      // userimage = logindata.getString("image1")!;
    });
  }

  LoginController logincontroller = Get.put(LoginController());

  String image = "";
  var name = Usererdatalist.NAME;
  var fname = Usererdatalist.F_NAME;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "Employe Profile",
                style: TextStyle(
                  fontSize: 34.0,
                  // fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundColor: kSecondaryColor,
            radius: 67,
            child: CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(
                  "https://thepointsystemapp.com/" + Usererdatalist.image),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),

                  // onPressed: () {},
                  child: Row(
                    children: [
                      Container(
                          child: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: kSecondaryColor,
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        // nameu,
                        name + " $fname",
                        style: TextStyle(fontSize: 20),
                      ))
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),

                  // onPressed: () {},
                  child: Row(
                    children: [
                      Container(
                          child: Icon(
                        Icons.email,
                        size: 35,
                        color: kSecondaryColor,
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        // usernamme,
                        Usererdatalist.EMAIL,
                        style: TextStyle(fontSize: 20),
                      ))
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),

                  // onPressed: () {},
                  child: Row(
                    children: [
                      Container(
                          child: Icon(
                        Icons.phone,
                        size: 35,
                        color: kSecondaryColor,
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        Usererdatalist.CELL_NO,
                        style: TextStyle(fontSize: 20),
                      ))
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),

                  // onPressed: () {},
                  child: Row(
                    children: [
                      Container(
                          child: Icon(
                        Icons.person_add,
                        size: 35,
                        color: kSecondaryColor,
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        Usererdatalist.Id_no,
                        style: TextStyle(fontSize: 20),
                      ))
                    ],
                  ))),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('username');

                  Get.offAll(Login());
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                    ),

                    // onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                            child: Icon(
                          Icons.logout,
                          size: 35,
                          color: kSecondaryColor,
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 20),
                        ))
                      ],
                    )),
              )),
        ],
      )
          // : Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
