// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/pub_lib.dart";

class AnnouncementGet extends StatefulWidget {
  dynamic data;

  AnnouncementGet({this.data, super.key});

  @override
  State<AnnouncementGet> createState() => AnnouncementGetState();
}

class AnnouncementGetState extends State<AnnouncementGet> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.data;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().content, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none),
                keyboardType: TextInputType.multiline,
                controller: controller,
                style: textStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
