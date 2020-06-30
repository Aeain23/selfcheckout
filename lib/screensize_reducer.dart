import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

double screenHeightMultiply(BuildContext context, {double multiplyBy = 1}) {
  return screenSize(context).height * multiplyBy;
}

double screenWidthMultiply(BuildContext context, {double multiplyBy = 1}) {
  return screenSize(context).width * multiplyBy;
}


