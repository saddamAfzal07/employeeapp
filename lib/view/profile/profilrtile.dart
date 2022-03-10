import 'package:flutter/material.dart';
import 'dart:io';

import 'package:employeeapp/controller/profile_controller/profile_controller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/camera/camera.dart';
import 'package:employeeapp/view/camera/daily_verify.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/profile/attendance.dart';
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

class ProfileTiles extends StatelessWidget {
  bool? warning, verified, notVerified;
  var date, status;

  ProfileTiles({
    this.date,
    this.status,
    this.warning = false,
    this.verified = false,
    this.notVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: warning == true
              ? kTertiaryColor
              : verified == true
                  ? kGreenColor
                  : kInputBorderColor,
        ),
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              warning == true
                  ? 'assets/images/Vector (9).png'
                  : verified == true
                      ? 'assets/images/Vector (8).png'
                      : 'assets/images/Vector (10).png',
              height: 20,
            ),
          ],
        ),
        title: MyText(
          text: '$date',
          size: 14,
        ),
        subtitle: MyText(
          text: '$status',
          size: 14,
          color: verified == true
              ? kGreenColor
              : warning == true
                  ? kTertiaryColor
                  : kBlackColor.withOpacity(0.6),
        ),
        trailing: GestureDetector(
          onTap: () => Get.to(() => DailyVerify()),
          child: Image.asset(
            'assets/images/Vector (7).png',
            height: 16,
            color: notVerified == true
                ? kSecondaryColor
                : kSecondaryColor.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

//check
class checkimage extends StatefulWidget {
  checkimage({Key? key}) : super(key: key);

  @override
  State<checkimage> createState() => _checkimageState();
}

class _checkimageState extends State<checkimage> {
  var pickedImage;
  var profilimagebase64;

  pickImage(ImageSource imageType) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final photo = await _picker.pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);

      setState(() {
        pickedImage = tempImage;

        // print(pickedImage);
        // final bytes = pickedImage.readAsBytesSync();
        // final bytes = File(pickedImage!.path).readAsBytesSync();
        profilimagebase64 = base64Encode(pickedImage.readAsBytesSync());
        // print("===>$bytes");
        // profilimagebase64 = base64Encode(bytes);
      });

      // print("=>>>>>>>");
      print(profilimagebase64);

      // Get.back();
    } catch (error) {
      print(error);
    }
  }

  imagefun() async {
    // isdatasubmit.value = true;
    print("Enter");

    // Map<String, dynamic> databody = {
    //   'image': pickedImage,
    //   'id': Usererdatalist.userid,
    //   'token': Usererdatalist.usertoken,
    // };
    // var datatosend = json.encode(databody);

    var response = await http.post(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/uniformCheck"),
        body: {
          'image': profilimagebase64,
          'id': Usererdatalist.userid,
          // 'token': Usererdatalist.usertoken,
        });
    // body: datatosend);

    print("image submit==>{$profilimagebase64}");
    print(Usererdatalist.userid);
    print(
      Usererdatalist.usertoken,
    );
    ////////////////
    print(response.body);
    if (response.statusCode == 200) {
      // isdatasubmit.value = false;
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      print("check=> done");
      // print(responsedata);

      print("check=> done");
      ///////////
      // print("data => +{$responsedata}");

      // print(responsedata["last_name"]);

      // Get.off(() => Profile());

      // Another method

      // Get.off(() => Profile());

      // isdatareading.value = true;
      ////////////////
    } else {
      // isdatasubmit.value = false;
      print("No submitted");
      Get.snackbar(
        "Not submit image",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );
    }
  }

  File? image;

  final _picker = ImagePicker();
  Future getimage() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
      });
    } else {
      print("Not any image is selected");
    }
  }

  bool imagesubmit = false;

  uploadImage() async {
    // print('token' + Usererdatalist.usertoken.toString());

    // ignore: unused_local_variable
    var token = Usererdatalist.usertoken;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unnecessary_new
    final multipartRequest = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/uniformCheck"));
    multipartRequest.headers.addAll(headers);

    multipartRequest.fields.addAll({
      "employee_id": Usererdatalist.userid,
    });

    multipartRequest.files
        .add(await http.MultipartFile.fromPath('image', image!.path));
    http.StreamedResponse response = await multipartRequest.send();

    var responseString = await response.stream.bytesToString();
    //  var responseString = String.fromCharCodes(responseString.toString());

    // print(response.toString());

    if (response.statusCode == 200) {
      setState(() {
        imagesubmit = true;
      });
      Get.snackbar(
        "Image upload Successfully",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );

      print(responseString);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: kGreenColor),
        ),
        child: ListTile(
            leading: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10),
              height: 60,
              width: 60,
              // color: Colors.green,
              child: imagesubmit
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    )
                  : image == null
                      ? Image.network(
                          'https://static.thenounproject.com/png/2413564-200.png',
                          // fit: BoxFit.cover,
                          height: 20,
                          width: 20,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Image.file(
                            File(image!.path).absolute,
                            // height: 100,
                            // width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
            ),
            title: Text("uniform check"),
            subtitle: GestureDetector(
              onTap: () {
                print("Button Click");
                uploadImage();
              },
              child: Container(
                  width: 30,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
            ),
            trailing: GestureDetector(
              onTap: () {
                getimage();
              },
              child: Image.asset(
                'assets/images/Vector (7).png',
                height: 24,
                width: 24,
              ),
            )),
      ),
    );
  }
}
