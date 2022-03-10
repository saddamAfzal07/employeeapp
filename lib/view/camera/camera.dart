import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_app_bar.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Verify Your Task',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: kInputBorderColor,
                  ),
                ),
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Vector (10).png',
                        height: 20,
                      ),
                    ],
                  ),
                  title: MyText(
                    text: 'Task header to be completed',
                    size: 14,
                  ),
                  subtitle: MyText(
                    text: '15:00 - 21:00',
                    size: 14,
                    color: kBlackColor.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Image.asset(
              'assets/images/Rectangle 16.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Vector (14).png',
                    height: 29,
                  ),
                  Image.asset(
                    'assets/images/Vector (15).png',
                    height: 28,
                  ),
                  Container(
                    width: 105,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kLightGreyColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                        child: Image.asset(
                      'assets/images/Vector (13).png',
                      height: 26,
                    )),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSecondaryColor,
                    ),
                    child: Center(
                        child: Image.asset(
                      'assets/images/Vector (8).png',
                      color: kPrimaryColor,
                      height: 26,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
