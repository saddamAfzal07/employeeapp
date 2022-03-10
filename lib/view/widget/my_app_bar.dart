import 'package:employeeapp/view/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_text.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(55);

  var title;

  MyAppBar({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Image.asset(
          'assets/images/Vector (11).png',
          height: 18,
          color: kSecondaryColor,
        ),
      ),
      title: MyText(
        text: "$title",
        size: 18,
        color: kSecondaryColor,
        weight: FontWeight.w500,
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
    );
  }
}
