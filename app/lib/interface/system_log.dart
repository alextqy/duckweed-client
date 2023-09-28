import "package:app/notifier/log_notifier.dart";
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
  DateTime setDate = DateTime.now();
  String ymd = "";

  LogNotifier logNotifier = LogNotifier();

  TextEditingController controller = TextEditingController();
  TextEditingController accountController = TextEditingController();

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
            Expanded(
              child: TextFormField(
                readOnly: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: textStyle(),
                ),
                keyboardType: TextInputType.multiline,
                controller: controller,
                style: textStyle(),
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: TextFormField(
                textAlign: TextAlign.center,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Lang().account,
                  hintStyle: textStyle(),
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                  //   onPressed: () async {
                  //     controller.clear();
                  //     accountController.clear();
                  //   },
                  // ),
                ),
                controller: accountController,
                style: textStyle(),
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: TextButton(
                child: Text(Lang().selectDate, style: textStyle()),
                onPressed: () async {
                  setState(() {
                    showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: setDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2099),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          setDate = value;
                          controller.clear();
                          ymd = value.toString().split(" ")[0];
                          if (ymd.isNotEmpty && accountController.text.isNotEmpty) {
                            logNotifier.viewLog(url: appUrl, date: ymd, account: accountController.text).then((value) {
                              if (value.data != null) {
                                controller.text = value.data;
                              }
                            });
                          }
                        });
                      }
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
