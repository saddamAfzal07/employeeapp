import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class keeplogin extends GetxController {
  SharedPreferences? logindata;
  bool? newuser;
  late SharedPreferences logindataa;
  late String usernamme;
  late String pass;

  void checkiflogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata!.getBool("login") ?? true);
    print(newuser);
    if (newuser == false) {
      logindataa = await SharedPreferences.getInstance();

      usernamme = logindataa.getString("username")!;
      pass = logindataa.getString("password")!;

      // nameu = logindata.getString("name")!;
      // fullname = logindata.getString("fullname")!;
      // id = logindata.getString("id")!;
      // userimage = logindata.getString("image1")!;

      // controller.Loginwithdetails(usernamme, pass);

      // Get.offAll(() => Profile());
      // print(newuser);
    }
  }
}
