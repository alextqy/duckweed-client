import "dart:io";

import "package:flutter/material.dart";

import "package:app/common/lang.dart";
import "package:app/common/file.dart";

import "package:app/notifier/user_notifier.dart";

import "package:app/main.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/routes.dart";
import "package:app/interface/common/show_alert_dialog.dart";

Drawer actionMenu(BuildContext context) {
  UserNotifier userNotifier = UserNotifier();
  bool master = bool.parse(FileHelper().jsonRead(key: "master"));

  dynamic menuHeader(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        // decoration: const BoxDecoration(color: Colors.black12),
        child: Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            SizedBox(
              height: 58,
              width: 58,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: SizedBox(
                    height: 53,
                    width: 53,
                    child: CircleAvatar(
                      backgroundColor: bgColor(context),
                      child: Text(FileHelper().jsonRead(key: "account").substring(0, 2), style: textStyle(fontSize: 24), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).push(RouteHelper().generate(context, "/personal/settings"));
                },
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  dynamic menuFooter(BuildContext context) {
    return Tooltip(
      message: Lang().longPressToExit,
      textStyle: textStyle(),
      decoration: tooltipStyle(),
      child: SizedBox(
        height: 35,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return bgColor(context);
            }),
          ),
          child: Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Text(Lang().exit, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(width: 10),
              Icon(Icons.exit_to_app, size: iconSize, color: iconColor),
            ],
          ),
          onLongPress: () async {
            FileHelper().jsonWrite(key: "current_page", value: "");
            FileHelper().jsonWrite(key: "account", value: "");
            userNotifier.signOut(url: appUrl).then((value) {
              if (value.state == true) {
                if (FileHelper().delFile("token")) {
                  exit(0);
                }
              } else {
                showSnackBar(context, content: value.message, backgroundColor: bgColor(context));
              }
            });
          },
          onPressed: () async {
            FileHelper().jsonWrite(key: "current_page", value: "");
            FileHelper().jsonWrite(key: "account", value: "");
            userNotifier.signOut(url: appUrl).then((value) {
              if (value.state == true) {
                if (FileHelper().delFile("token")) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage(title: appTitle)),
                    (route) => false,
                  );
                }
              } else {
                showSnackBar(context, content: value.message, backgroundColor: bgColor(context));
              }
            });
          },
        ),
      ),
    );
  }

  return Drawer(
    width: screenSize(context).width > 800 ? screenSize(context).width * 0.2 : screenSize(context).width * 0.45,
    backgroundColor: Colors.black54,
    child: Column(
      children: [
        menuHeader(context),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              ListTile(
                horizontalTitleGap: 20,
                leading: Icon(Icons.home, size: iconSize, color: iconColor),
                title: Text(Lang().home, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () async {
                  Navigator.of(context).push(RouteHelper().generate(context, "/"));
                },
              ),
              ListTile(
                horizontalTitleGap: 20,
                leading: Icon(Icons.cloud_upload, size: iconSize, color: iconColor),
                title: Text(Lang().upload, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () async {
                  Navigator.of(context).push(RouteHelper().generate(context, "/uploading"));
                },
              ),
              ListTile(
                horizontalTitleGap: 20,
                leading: Icon(Icons.cloud_download, size: iconSize, color: iconColor),
                title: Text(Lang().download, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () async {
                  Navigator.of(context).push(RouteHelper().generate(context, "/downloading"));
                },
              ),
              Visibility(
                visible: master ? true : false,
                child: ListTile(
                  horizontalTitleGap: 20,
                  leading: Icon(Icons.people, size: iconSize, color: iconColor),
                  title: Text(Lang().users, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    Navigator.of(context).push(RouteHelper().generate(context, "/users"));
                  },
                ),
              ),
              Visibility(
                visible: master ? true : false,
                child: ListTile(
                  horizontalTitleGap: 20,
                  leading: Icon(Icons.chat, size: iconSize, color: iconColor),
                  title: Text(Lang().announcements, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    Navigator.of(context).push(RouteHelper().generate(context, "/announcements"));
                  },
                ),
              ),
              Visibility(
                visible: master ? true : false,
                child: ListTile(
                  horizontalTitleGap: 20,
                  leading: Icon(Icons.collections_bookmark, size: iconSize, color: iconColor),
                  title: Text(Lang().systemLog, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () async {
                    Navigator.of(context).push(RouteHelper().generate(context, "/system/log"));
                  },
                ),
              ),
            ],
          ),
        ),
        ListTile(horizontalTitleGap: 10, title: Text("v 0.1.0", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
        menuFooter(context),
      ],
    ),
  );
}
