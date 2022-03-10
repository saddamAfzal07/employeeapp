import 'package:employeeapp/view/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MyText extends StatelessWidget {
  var text, color, weight, align, decoration, fontFamily;
  double? size;
  double? paddingTop, paddingLeft, paddingRight, paddingBottom;
  var maxlines, overFlow;

  MyText({
    Key? key,
    this.text,
    this.size,
    this.maxlines = 100,
    this.decoration = TextDecoration.none,
    this.color = kBlackColor,
    this.weight = FontWeight.w400,
    this.align,
    this.overFlow,
    this.fontFamily = 'Sf Pro Display',
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: Text(
        "$text",
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          decoration: decoration,
          fontFamily: '$fontFamily',
        ),
        textAlign: align,
        maxLines: maxlines,
        overflow: overFlow,
      ),
    );
  }
}