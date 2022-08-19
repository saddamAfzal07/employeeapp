// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/view/camera/daily_verify.dart';
import 'package:employeeapp/view/constant/constant.dart';

import 'package:employeeapp/view/widget/my_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart' hide Action;

// ignore: must_be_immutable
class ProfileTiles extends StatefulWidget {
  bool? warning, verified, notVerified;
  var date, status;

  @override
  State<ProfileTiles> createState() => _ProfileTilesState();
}

class _ProfileTilesState extends State<ProfileTiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: widget.warning == true
              ? kTertiaryColor
              : widget.verified == true
                  ? kGreenColor
                  : kInputBorderColor,
        ),
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.warning == true
                  ? 'assets/images/Vector (9).png'
                  : widget.verified == true
                      ? 'assets/images/Vector (8).png'
                      : 'assets/images/Vector (10).png',
              height: 20,
            ),
          ],
        ),
        title: MyText(
          text: '${widget.date}',
          size: 14,
        ),
        subtitle: MyText(
          text: '${widget.status}',
          size: 14,
          color: widget.verified == true
              ? kGreenColor
              : widget.warning == true
                  ? kTertiaryColor
                  : kBlackColor.withOpacity(0.6),
        ),
        trailing: GestureDetector(
          onTap: () => Get.to(() => DailyVerify()),
          child: Image.asset(
            'assets/images/Vector (7).png',
            height: 16,
            color: widget.notVerified == true
                ? kSecondaryColor
                : kSecondaryColor.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

//check
// ignore: camel_case_types
class checkimage extends StatefulWidget {
  const checkimage({Key? key}) : super(key: key);

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

        profilimagebase64 = base64Encode(pickedImage.readAsBytesSync());
      });
    } catch (error) {}
  }

  imagefun() async {
    var response = await http.post(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/uniformCheck"),
        body: {
          'image': profilimagebase64,
          'id': Usererdatalist.userid,
        });

    ////////////////
    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);

      ///////////

      ////////////////
    } else {
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
    } else {}
  }

  bool imagesubmit = false;

  uploadImage() async {
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
              child: imagesubmit
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    )
                  : image == null
                      ? Image.network(
                          'https://static.thenounproject.com/png/2413564-200.png',
                          height: 20,
                          width: 20,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Image.file(
                            File(image!.path).absolute,
                            fit: BoxFit.cover,
                          ),
                        ),
            ),
            title: Text("uniform check"),
            subtitle: GestureDetector(
              onTap: () {
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
