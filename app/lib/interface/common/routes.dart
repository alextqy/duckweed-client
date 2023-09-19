import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/common/file.dart";

import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/home_page.dart";
import "package:app/interface/personal_settings.dart";
import "package:app/interface/users.dart";
import "package:app/interface/announcements.dart";
import "package:app/interface/system_log.dart";

import "package:app/interface/announcement_add.dart";

class RouteHelper {
  dynamic generate(BuildContext context, String routeName, {dynamic data}) {
    // if (routeName != FileHelper().jsonRead(key: "current_page")) {
    FileHelper().jsonWrite(key: "current_page", value: routeName);
    switch (routeName) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());
      case "/personal/settings":
        return MaterialPageRoute(builder: (context) => const PersonalSettings());
      case "/users":
        return MaterialPageRoute(builder: (context) => const Users());
      case "/announcements":
        return MaterialPageRoute(builder: (context) => const Announcements());
      case "/system/log":
        return MaterialPageRoute(builder: (context) => const SystemLog());
      case "/announcement/add":
        return MaterialPageRoute(builder: (context) => const AnnouncementAdd());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              toolbarHeight: toolbarHeight,
              backgroundColor: bgColor(context),
              title: Text("Error", style: textStyle(fontSize: 20), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            body: Center(child: Text(Lang().invalidPage, style: textStyle(fontSize: 30), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ),
        );
    }
    // }
  }
}
