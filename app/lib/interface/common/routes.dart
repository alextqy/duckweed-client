import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/home_page.dart";

class RouteHelper {
  dynamic generate(BuildContext context, String routeName, {dynamic data}) {
    switch (routeName) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());
      case "/Users":
      // return MaterialPageRoute(builder: (context) => ());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text("", style: textStyle(fontSize: 15))),
            body: Center(child: Text(Lang().invalidPage, style: textStyle(fontSize: 30))),
          ),
        );
    }
  }
}
