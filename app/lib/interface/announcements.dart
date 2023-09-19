import "dart:convert";

import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/common/tools.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/announcement_notifier.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/show_alert_dialog.dart";

import "package:app/model/announcement_model.dart";

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> with TickerProviderStateMixin {
  int page = 1;
  int pageSize = 10;
  int order = -1;
  int totalPage = 0;

  AnnouncementNotifier announcementNotifier = AnnouncementNotifier();

  void fetchData() {
    announcementNotifier.announcements(url: appUrl).then((value) {
      setState(() {
        announcementNotifier.announcementListModel = AnnouncementModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  List<ListTile> generateList() {
    List<ListTile> dataList = [];
    for (AnnouncementModel a in announcementNotifier.announcementListModel) {
      String createtime = Tools().timestampToStr(a.createtime).split(" ")[0];
      dataList.add(
        ListTile(
          title: Tooltip(
            message: a.content,
            textStyle: textStyle(),
            decoration: tooltipStyle(),
            child: Text(a.content, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          subtitle: Text("${Lang().createtime}: $createtime", style: textStyle(fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, size: 30, color: iconColor),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, Function state) {
                      return AlertDialog(
                        content: Text("${Lang().confirm}?", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              announcementNotifier.announcementDel(url: appUrl, id: a.id);
                              Navigator.of(context).pop();
                            },
                            child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          onTap: () async {},
        ),
      );
    }
    return dataList;
  }

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (announcementNotifier.operationStatus.value == OperationStatus.success) {
      fetchData();
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: announcementNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    announcementNotifier.addListener(basicListener);
    fetchData();
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
      endDrawer: actionMenu(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().announcements, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: generateList(),
              ),
            ),
            Container(margin: const EdgeInsets.all(0), height: 1, color: Colors.white70),
            Container(margin: const EdgeInsets.all(0), height: 10, color: Colors.transparent),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              alignment: Alignment.center,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(Icons.add_outlined, size: 35, color: iconColor),
                onPressed: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
