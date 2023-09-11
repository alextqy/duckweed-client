import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/home_page.dart";
import "package:app/interface/personal_settings.dart";

class RouteHelper {
  dynamic generate(BuildContext context, String routeName, {dynamic data}) {
    switch (routeName) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());
      case "/personal/settings":
        return MaterialPageRoute(builder: (context) => const PersonalSettings());
      case "/users":
      // return MaterialPageRoute(builder: (context) => ());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              toolbarHeight: toolbarHeight,
              backgroundColor: bgColor(context),
              title: Text("Error", style: textStyle(fontSize: 20)),
            ),
            body: Center(child: Text(Lang().invalidPage, style: textStyle(fontSize: 30))),
          ),
        );
    }
  }
}