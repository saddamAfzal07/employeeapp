import 'package:employeeapp/view/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_text.dart';

class MyButton extends StatefulWidget {
  var text, weight;
  double? textSize, height;
  VoidCallback? onPressed;

  MyButton({
    this.text,
    this.textSize,
    this.height = 59,
    this.weight = FontWeight.w400,
    this.onPressed,
  });

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      onPressed: widget.onPressed,
      color: kSecondaryColor,
      height: widget.height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      child: MyText(
        text: "${widget.text}",
        color: kPrimaryColor,
        size: widget.textSize,
        weight: widget.weight,
      ),
    );
  }
}
