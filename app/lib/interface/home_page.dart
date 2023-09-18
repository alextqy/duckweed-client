import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/marquee.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> content = [
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    "bbbbbbbbbbbbb",
    "cccccccccccccc",
    "ddddddddddddddddd",
  ];

  bool showMarquee = true;

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
        title: Text(Lang().home, style: textStyle()),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Visibility(
              visible: showMarquee,
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: double.infinity,
                height: 35,
                alignment: Alignment.center,
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(child: Marquee(data: content)),
                    SizedBox(
                      width: 45,
                      child: Tooltip(
                        message: Lang().hideBulletinBoard,
                        textStyle: textStyle(),
                        decoration: tooltipStyle(),
                        child: IconButton(
                          icon: const Icon(Icons.disabled_visible_outlined, size: 20, color: Colors.white),
                          onPressed: () async {
                            setState(() {
                              showMarquee = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(0),
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
