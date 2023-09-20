import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/announcement_notifier.dart";

import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/interface/common/pub_lib.dart";

class AnnouncementAdd extends StatefulWidget {
  const AnnouncementAdd({super.key});

  @override
  State<AnnouncementAdd> createState() => AnnouncementAddState();
}

class AnnouncementAddState extends State<AnnouncementAdd> with TickerProviderStateMixin {
  AnnouncementNotifier announcementNotifier = AnnouncementNotifier();

  TextEditingController controller = TextEditingController();

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (announcementNotifier.operationStatus.value == OperationStatus.success) {
      controller.clear();
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: announcementNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    announcementNotifier.addListener(basicListener);
    super.initState();
  }

  @override
  void dispose() {
    announcementNotifier.removeListener(basicListener);
    announcementNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().addAnnouncement, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Lang().content,
                  hintStyle: textStyle(),
                ),
                keyboardType: TextInputType.multiline,
                controller: controller,
                style: textStyle(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    height: 30,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.transparent),
                    child: TextButton(
                      child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          announcementNotifier.announcementAdd(url: appUrl, content: controller.text);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
