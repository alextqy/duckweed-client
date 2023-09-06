// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:app/common/file.dart';

class HomePage extends StatefulWidget {
  String title = FileHelper().jsonRead(key: "title");

  HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextStyle textStyle({Color color = Colors.white70, double fontSize = 15}) {
    return TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: fontSize, textBaseline: TextBaseline.alphabetic);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.inversePrimary;

    Size screenSize = MediaQuery.of(context).size;

    Drawer actionMenu(BuildContext context) {
      return Drawer(
        width: screenSize.width * 0.4,
        backgroundColor: Colors.black54,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            ListTile(
              horizontalTitleGap: 20,
              leading: const Icon(Icons.search_outlined, size: 20),
              title: Text(
                "...",
                style: textStyle(),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );
    }

    return Scaffold(
      endDrawer: actionMenu(context),
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: bgColor,
        title: Text(widget.title, style: textStyle()),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Expanded(child: SizedBox()),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
