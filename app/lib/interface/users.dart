import "dart:convert";

import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/common/tools.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/user_notifier.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/show_alert_dialog.dart";

import "package:app/model/user_model.dart";
import "package:flutter/services.dart";

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

  List<ListTile> generateList() {
    List<ListTile> dataList = [];
    for (UserModel u in userNotifier.userListModel) {
      String root = u.level == 2 ? Lang().yes : Lang().no;
      String disable = u.status == 1 ? Lang().no : Lang().yes;
      String createtime = Tools().timestampToStr(u.createtime).split(" ")[0];
      dataList.add(
        ListTile(
          title: Text("${Lang().account}: ${u.account}", style: textStyle()),
          subtitle: Text("${Lang().createtime}: $createtime", style: textStyle(fontSize: 12.5)),
          enabled: u.status == 1 ? true : false,
          leading: u.level == 2 ? const Icon(Icons.manage_accounts_outlined) : const Icon(Icons.person_outline),

          /// 设置为管理员
          onLongPress: () async {
            setState(() {
              userNotifier.setRootAccount(url: appUrl, id: u.id);
            });
          },

          trailing: PopupMenuButton<ListTileTitleAlignment>(
            tooltip: "",
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ListTileTitleAlignment>>[
              PopupMenuItem<ListTileTitleAlignment>(
                child: Text(Lang().details),
                onTap: () async {
                  userNotifier.userGet(url: appUrl, id: u.id).then((value) {
                    userNotifier.userModel = UserModel.fromJson(value.data);
                    showAlertWidget(
                      context,
                      Container(
                        height: 200,
                        width: screenSize(context).width * 0.2,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 250,
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      "${Lang().nickName}: ${userNotifier.userModel.name}",
                                      style: textStyle(),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 250,
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    child: Tooltip(
                                      message: u.email,
                                      child: Text(
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        "${Lang().email}: ${userNotifier.userModel.email}",
                                        style: textStyle(),
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Text("${Lang().root}: $root", style: textStyle()),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Text("${Lang().disable}: $disable", style: textStyle()),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
              PopupMenuItem<ListTileTitleAlignment>(
                child: Text(Lang().availableSpace),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      int currentSliderValue = u.availableSpace;
                      TextEditingController currentSliderValueController = TextEditingController();
                      currentSliderValueController.text = currentSliderValue.toString();
                      return UnconstrainedBox(
                        constrainedAxis: Axis.vertical, // 取消原有宽高限制
                        child: StatefulBuilder(
                          builder: (BuildContext context, Function state) {
                            return Dialog(
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                height: 100,
                                width: screenSize(context).width * 0.2,
                                child: Column(
                                  children: [
                                    // const Expanded(child: SizedBox()),
                                    Container(
                                      margin: const EdgeInsets.all(0),
                                      padding: const EdgeInsets.all(0),
                                      alignment: Alignment.topCenter,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.all(0),
                                              padding: const EdgeInsets.all(0),
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                                                color: Colors.transparent,
                                              ),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                child: Center(child: Icon(size: iconSize, Icons.arrow_back_ios, color: Colors.white70)),
                                                onTap: () async {
                                                  state(() {
                                                    currentSliderValue -= 512;
                                                    currentSliderValueController.text = currentSliderValue.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: TextField(
                                              style: textStyle(fontSize: 20),
                                              controller: currentSliderValueController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                              decoration: const InputDecoration(border: InputBorder.none),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(width: 35, child: Center(child: Text("M", style: textStyle()))),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.all(0),
                                              padding: const EdgeInsets.all(0),
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
                                                color: Colors.transparent,
                                              ),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                child: Center(child: Icon(size: iconSize, Icons.arrow_forward_ios, color: Colors.white70)),
                                                onTap: () async {
                                                  state(() {
                                                    currentSliderValue += 512;
                                                    currentSliderValueController.text = currentSliderValue.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(0),
                                            padding: const EdgeInsets.all(0),
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                              color: Colors.transparent,
                                            ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              child: Center(child: Text("OK", style: textStyle())),
                                              onTap: () async {
                                                state(() {
                                                  userNotifier.setAvailableSpace(url: appUrl, id: u.id, availableSpace: currentSliderValueController.text);
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Expanded(child: SizedBox()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              PopupMenuItem<ListTileTitleAlignment>(
                value: ListTileTitleAlignment.top,
                child: Text(Lang().disable),
                onTap: () async {
                  setState(() {
                    userNotifier.disableUser(url: appUrl, id: u.id);
                  });
                },
              ),
              PopupMenuItem<ListTileTitleAlignment>(
                value: ListTileTitleAlignment.top,
                child: Text(Lang().delete),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, Function state) {
                          return AlertDialog(
                            content: Text("${Lang().confirm}?", style: textStyle()),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  userNotifier.userDel(url: appUrl, id: u.id);
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK", style: textStyle()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return dataList;
  }

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (userNotifier.operationStatus.value == OperationStatus.success) {
      fetchData();
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: generateList(),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
