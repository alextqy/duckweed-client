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
  int totalPage = 0;
  int levelSearch = 0;
  int statusSearch = 0;
  String accountSearch = "";
  String nameSearch = "";

  UserNotifier userNotifier = UserNotifier();

  List<String> pageList = <String>["10", "30", "50"];

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
        page = value.page;
        pageSize = value.pageSize;
        totalPage = value.totalPage;
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
          title: Tooltip(
            message: u.account,
            textStyle: textStyle(),
            decoration: tooltipStyle(),
            child: Text(
              "${Lang().account}: ${u.account}",
              style: textStyle(color: u.status == 1 ? iconColor : Colors.deepOrange),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            "${Lang().createtime}: $createtime",
            style: textStyle(
              fontSize: 12.5,
              color: u.status == 1 ? iconColor : Colors.deepOrange,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          enabled: u.status == 1 ? true : false,
          leading: u.level == 2
              ? Icon(
                  Icons.manage_accounts_outlined,
                  color: u.status == 1 ? iconColor : Colors.deepOrange,
                )
              : Icon(
                  Icons.person_outline,
                  color: u.status == 1 ? iconColor : Colors.deepOrange,
                ),

          /// 设置为管理员
          onLongPress: () async {
            setState(() {
              userNotifier.setRootAccount(url: appUrl, id: u.id);
            });
          },

          trailing: PopupMenuButton<ListTileTitleAlignment>(
            tooltip: "",
            color: iconColor,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ListTileTitleAlignment>>[
              PopupMenuItem<ListTileTitleAlignment>(
                value: ListTileTitleAlignment.center,
                child: Text(
                  "${Lang().copy} ${Lang().account}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(color: Colors.black),
                ),
                onTap: () async {
                  copy(u.account);
                  showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
                },
              ),
              PopupMenuItem<ListTileTitleAlignment>(
                value: ListTileTitleAlignment.center,
                child: Text(Lang().details, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle(color: Colors.black)),
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
                                    child: Tooltip(
                                      message: u.name,
                                      textStyle: textStyle(),
                                      decoration: tooltipStyle(),
                                      child: Text(
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        "${Lang().nickName}: ${userNotifier.userModel.name}",
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
                                  Container(
                                    width: 250,
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    child: Tooltip(
                                      message: u.email,
                                      textStyle: textStyle(),
                                      decoration: tooltipStyle(),
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
                                  Text("${Lang().root}: $root", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Text("${Lang().disable}: $disable", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                value: ListTileTitleAlignment.center,
                child: Text(Lang().availableSpace, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle(color: Colors.black)),
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
                                            flex: 3,
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
                                                child: Tooltip(
                                                  preferBelow: false,
                                                  message: "512",
                                                  textStyle: textStyle(),
                                                  decoration: tooltipStyle(),
                                                  child: Center(child: Icon(size: iconSize, Icons.remove, color: iconColor)),
                                                ),
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
                                            child: TextFormField(
                                              style: textStyle(fontSize: 20),
                                              controller: currentSliderValueController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                              decoration: const InputDecoration(border: InputBorder.none),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 35,
                                            child: Center(
                                              child: Text(
                                                "M",
                                                style: textStyle(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
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
                                                child: Tooltip(
                                                  preferBelow: false,
                                                  message: "512",
                                                  textStyle: textStyle(),
                                                  decoration: tooltipStyle(),
                                                  child: Center(child: Icon(size: iconSize, Icons.add, color: iconColor)),
                                                ),
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
                                              child: Center(child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
                value: ListTileTitleAlignment.center,
                child: Text(
                  u.status == 1 ? Lang().disable : Lang().enable,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(color: Colors.black),
                ),
                onTap: () async {
                  setState(() {
                    userNotifier.disableUser(url: appUrl, id: u.id);
                  });
                },
              ),
              PopupMenuItem<ListTileTitleAlignment>(
                value: ListTileTitleAlignment.center,
                child: Text(Lang().delete, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle(color: Colors.black)),
                onTap: () async {
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
                                  userNotifier.userDel(url: appUrl, id: u.id);
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
    userNotifier.addListener(basicListener);
    fetchData();
    super.initState();
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
        title: Text(Lang().users, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(margin: const EdgeInsets.all(0), height: 5, color: Colors.transparent),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      Lang().root,
                      style: textStyle(color: levelSearch == 0 ? Colors.grey : Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () async {
                      setState(() {
                        if (levelSearch == 0) {
                          levelSearch = 2;
                        } else {
                          levelSearch = 0;
                        }
                        fetchData();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(
                      Lang().disable,
                      style: textStyle(color: statusSearch == 0 ? Colors.grey : Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () async {
                      setState(() {
                        if (statusSearch == 0) {
                          statusSearch = 2;
                        } else {
                          statusSearch = 0;
                        }
                        fetchData();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    height: 30,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: pageSize.toString(),
                      style: textStyle(),
                      underline: Container(height: 0),
                      focusColor: Colors.transparent,
                      onChanged: (String? value) async {
                        setState(() {
                          page = 1;
                          if (value != null) {
                            pageSize = int.parse(value);
                          }
                          fetchData();
                        });
                      },
                      items: pageList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: textStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Container(margin: const EdgeInsets.all(0), height: 10, color: Colors.transparent),
            Container(margin: const EdgeInsets.all(0), height: 1, color: Colors.white70),
            Container(margin: const EdgeInsets.all(0), height: 10, color: Colors.transparent),
            Expanded(
              flex: 7,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: generateList(),
              ),
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: iconSize, color: iconColor),
                    onPressed: () async {
                      setState(() {
                        page -= 1;
                        fetchData();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: order == -1
                        ? Icon(
                            Icons.keyboard_double_arrow_down,
                            size: 25,
                            color: iconColor,
                          )
                        : Icon(
                            Icons.keyboard_double_arrow_up,
                            size: 25,
                            color: iconColor,
                          ),
                    onPressed: () async {
                      setState(() {
                        if (order < 0) {
                          order = 1;
                        } else {
                          order = -1;
                        }
                        page = 1;
                        fetchData();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: iconSize, color: iconColor),
                    onPressed: () async {
                      setState(() {
                        page += 1;
                        fetchData();
                      });
                    },
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
