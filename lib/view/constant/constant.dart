import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xffffffff);
const kSecondaryColor = Color(0xff007AFF);
const kTertiaryColor = Color(0xffEA8C47);
const kYellowColor = Color(0xffF99954);
const kBlackColor = Color(0xff000000);
const kGreyColor = Color(0xffC4C4C4);
const kGreenColor = Color(0xff5EB01E);
const kLightGreyColor = Color(0xffECECEC);
const kInputBorderColor = Color(0xffE7E7E7);

var blueGradientEffectCircle = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xff007AFF),
    Color(0xff5E99DA),
  ],
);
var blueGradientEffect = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff007AFF),
    Color(0xff5E99DA),
  ],
);
var orangeGradientEffect = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xffF99954),
    Color(0xffCC702E),
  ],
);
