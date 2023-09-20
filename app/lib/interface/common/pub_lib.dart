import "package:flutter/material.dart";
import "package:app/common/file.dart";
import "package:flutter/services.dart";

String appUrl = FileHelper().setUrl();
double toolbarHeight = 37;
String appTitle = FileHelper().jsonRead(key: "title");
String appAccount = FileHelper().jsonRead(key: "account");

int showSpeed = 450;
double iconSize = 20;
Color iconColor = Colors.white70;

BoxDecoration tooltipStyle() {
  return const BoxDecoration(borderRadius: BorderRadius.all(Radius.elliptical(10, 10)), color: Colors.black);
}

TextStyle textStyle({Color color = Colors.white70, double fontSize = 15}) {
  return TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: fontSize, textBaseline: TextBaseline.alphabetic);
}

Color bgColor(BuildContext context) {
  return Theme.of(context).colorScheme.inversePrimary;
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

void copy(String param) {
  Clipboard.setData(ClipboardData(text: param));
}

Future<ClipboardData?> paste() {
  return Clipboard.getData(Clipboard.kTextPlain);
}
