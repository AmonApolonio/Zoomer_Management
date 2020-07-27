import 'package:flutter/material.dart';

//code to remove the scroll glow, that I used on some listviews for aesthetic reasons

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
