import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  bool? isObSecure;
  var hintText, labelText;

  MyTextField({
    this.hintText,
    this.labelText,
    this.isObSecure = false,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  var labelColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            labelColor =
                hasFocus ? kSecondaryColor : kBlackColor.withOpacity(0.6);
          });
        },
        child: TextFormField(
          onTap: () {},
          cursorColor: kGreyColor,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontSize: 18,
            color: kBlackColor.withOpacity(0.6),
          ),
          obscureText: widget.isObSecure!,
          obscuringCharacter: "*",
          decoration: InputDecoration(
            labelText: '${widget.labelText}',
            labelStyle: TextStyle(
              fontSize: 18,
              color: labelColor,
            ),
            hintText: "${widget.hintText}",
            hintStyle: TextStyle(
              fontSize: 18,
              color: kBlackColor.withOpacity(0.6),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 23),
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
    );
  }
}
