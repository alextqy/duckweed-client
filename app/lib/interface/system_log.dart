import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";

class SystemLog extends StatefulWidget {
  const SystemLog({super.key});

  @override
  State<SystemLog> createState() => SystemLogState();
}

class SystemLogState extends State<SystemLog> with TickerProviderStateMixin {
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
        title: Text(Lang().systemLog, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            Container(
              height: 35,
              width: double.infinity,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: TextButton(
                child: Text(Lang().selectDate, style: textStyle()),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
