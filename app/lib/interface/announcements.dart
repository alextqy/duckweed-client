import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: actionMenu(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().announcements, style: textStyle()),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
