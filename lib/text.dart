import 'package:flutter_neumorphic/flutter_neumorphic.dart';

NeumorphicText neumorphicH1(String text) {
  return NeumorphicText(text,
      textStyle: NeumorphicTextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      style: NeumorphicStyle(color: Color(0xFF000000)));
}

NeumorphicText neumorphicH2(String text) {
  return NeumorphicText(text,
      textStyle: NeumorphicTextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w400,
      ),
      style: NeumorphicStyle(color: Color(0xAA000000)));
}
