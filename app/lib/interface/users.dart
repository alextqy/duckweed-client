// ignore_for_file: must_be_immutable

import "dart:convert";

import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/user_notifier.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/show_alert_dialog.dart";

import "package:app/model/user_model.dart";

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => UsersState();
}

class UsersState extends State<Users> with TickerProviderStateMixin {
  int page = 1;
  int pageSize = 10;
  int order = -1;
  String accountSearch = "";
  String nameSearch = "";
  int levelSearch = 0;
  int statusSearch = 0;

  UserNotifier userNotifier = UserNotifier();

  void fetchData() {
    userNotifier
        .userList(
      url: appUrl,
      page: page,
      pageSize: pageSize,
      order: order,
      account: accountSearch,
      name: nameSearch,
      level: levelSearch,
      status: statusSearch,
    )
        .then((value) {
      setState(() {
        userNotifier.userListModel = UserModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (userNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: userNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    super.initState();
    userNotifier.addListener(basicListener);

    fetchData();
  }

  @override
  void dispose() {
    userNotifier.removeListener(basicListener);
    userNotifier.dispose();
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
        title: Text(Lang().users, style: textStyle()),
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
