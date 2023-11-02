// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";

import "package:app/common/lang.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> with TickerProviderStateMixin {
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
        title: Text(Lang().uploading, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Expanded(child: SizedBox.shrink()),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
