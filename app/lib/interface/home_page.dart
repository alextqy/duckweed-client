import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:app/common/lang.dart";
import "package:file_selector/file_selector.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/announcement_notifier.dart";
import "package:app/notifier/dir_notifier.dart";
import "package:app/notifier/file_notifier.dart";

import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/marquee.dart";

import "package:app/model/announcement_model.dart";
import "package:app/model/dir_model.dart";
import "package:app/model/file_model.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> content = [];
  List<dynamic> itemList = [];

  bool isSelectionMode = false;
  List<bool> itemSelected = [];
  bool selectAll = false;
  bool isGridMode = false;

  AnnouncementNotifier announcementNotifier = AnnouncementNotifier();
  DirNotifier dirNotifier = DirNotifier();
  FileNotifier fileNotifier = FileNotifier();

  bool showMarquee = true;
  int order = -1;
  int parentID = 0;
  String searchDirName = "";
  String searchFileName = "";

  void fetchAnnouncementData() {
    announcementNotifier.announcements(url: appUrl).then((value) {
      setState(() {
        announcementNotifier.announcementListModel = AnnouncementModel().fromJsonList(jsonEncode(value.data));
        for (AnnouncementModel a in announcementNotifier.announcementListModel) {
          content.add(a.content);
        }
      });
    });
  }

  void fetchData() {
    dirNotifier.dirs(url: appUrl, order: order, parentID: parentID, dirName: searchDirName).then((value) {
      setState(() {
        itemList.addAll(DirModel().fromJsonList(jsonEncode(value.data)));
        fileNotifier.files(url: appUrl, order: order, dirID: parentID, fileName: searchFileName).then((value) {
          setState(() {
            itemList.addAll(FileModel().fromJsonList(jsonEncode(value.data)));
            initializeSelection(context);
          });
        });
      });
    });
  }

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);

    if (dirNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: dirNotifier.operationMemo, backgroundColor: bgColor(context));
    }

    if (fileNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: fileNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  void initializeSelection(BuildContext context) {
    itemSelected = List<bool>.generate(itemList.length, (context) => false);
  }

  @override
  void initState() {
    fetchAnnouncementData();
    fetchData();
    dirNotifier.addListener(basicListener);
    super.initState();
  }

  @override
  void dispose() {
    dirNotifier.removeListener(basicListener);
    dirNotifier.dispose();
    itemList.clear();
    super.dispose();
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(Icons.folder_rounded, color: iconColor, size: iconSize),
                const SizedBox(width: 10),
                Text(Lang().newFolder, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Expanded(child: SizedBox()),
              ],
            ),
            onPressed: () async {
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  TextEditingController textController = TextEditingController();
                  return UnconstrainedBox(
                    constrainedAxis: Axis.vertical, // 取消原有宽高限制
                    child: StatefulBuilder(
                      builder: (BuildContext context, Function state) {
                        return Dialog(
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(20),
                            height: screenSize(context).height * 0.2,
                            width: 200,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: textStyle(),
                                  controller: textController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                                      onPressed: () async => textController.clear(),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                TextButton(
                                  child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  onPressed: () async {
                                    if (textController.text.isNotEmpty) {
                                      dirNotifier.dirAction(url: appUrl, dirName: textController.text, parentID: parentID, id: 0);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
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
          CupertinoActionSheetAction(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(Icons.upload_rounded, color: iconColor, size: iconSize),
                const SizedBox(width: 10),
                Text(Lang().uploadFiles, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Expanded(child: SizedBox()),
              ],
            ),
            onPressed: () async {
              Navigator.pop(context);
              fileSelector(["*"]).then((value) {
                if (value.isNotEmpty) {
                  for (XFile f in value) {
                    print(f.path);
                  }
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(Icons.download_rounded, color: iconColor, size: iconSize),
                const SizedBox(width: 10),
                Text(Lang().downloadFiles, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Expanded(child: SizedBox()),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              int i = 0;
              for (bool element in itemSelected) {
                if (element) {
                  if (itemList[i] is DirModel) {
                    DirModel dirObj = itemList[i];
                    print(dirObj.dirName);
                  }
                  if (itemList[i] is FileModel) {
                    FileModel fileObj = itemList[i];
                    print(fileObj.fileName);
                  }
                }
                i++;
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(Icons.delete_rounded, color: Colors.red, size: iconSize),
                const SizedBox(width: 10),
                Text(Lang().delete, style: textStyle(fontSize: 18, color: Colors.red), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Expanded(child: SizedBox()),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              int i = 0;
              for (bool element in itemSelected) {
                if (element) {
                  if (itemList[i] is DirModel) {
                    DirModel dirObj = itemList[i];
                    print(dirObj.dirName);
                  }
                  if (itemList[i] is FileModel) {
                    FileModel fileObj = itemList[i];
                    print(fileObj.fileName);
                  }
                }
                i++;
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Icon(Icons.arrow_circle_down_rounded, color: iconColor, size: 35),
                const Expanded(child: SizedBox()),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: actionMenu(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().home, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Visibility(
              visible: showMarquee,
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: double.infinity,
                height: 35,
                alignment: Alignment.center,
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(child: Marquee(data: content, url: "/announcement/get")),
                    SizedBox(
                      width: 45,
                      child: Tooltip(
                        // message: Lang().hideBulletinBoard,
                        message: "",
                        textStyle: textStyle(),
                        decoration: tooltipStyle(),
                        child: IconButton(
                          icon: Icon(Icons.disabled_visible_outlined, size: 20, color: iconColor),
                          onPressed: () async {
                            setState(() {
                              showMarquee = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: showMarquee,
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                color: Colors.white70,
                height: 1,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(0),
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: isGridMode
                    ? GridBuilder(
                        dataList: itemList,
                        isSelectionMode: isSelectionMode,
                        selectedList: itemSelected,
                        onSelectionChange: (bool x) {
                          setState(() {
                            isSelectionMode = x;
                          });
                        },
                      )
                    : ListBuilder(
                        dataList: itemList,
                        isSelectionMode: isSelectionMode,
                        selectedList: itemSelected,
                        onSelectionChange: (bool x) {
                          setState(() {
                            isSelectionMode = x;
                          });
                        },
                      ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.menu_open_outlined, size: 30, color: iconColor),
                    onPressed: () async => showActionSheet(context),
                  ),
                  if (isGridMode)
                    IconButton(
                      icon: Icon(Icons.grid_view_rounded, size: 25, color: iconColor),
                      onPressed: () async {
                        setState(() {
                          isGridMode = false;
                        });
                      },
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.table_rows_rounded, size: 25, color: iconColor),
                      onPressed: () async {
                        setState(() {
                          isGridMode = true;
                        });
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.check_box_outlined, size: 25, color: iconColor),
                    onPressed: () async {
                      setState(() {
                        if (isSelectionMode) {
                          selectAll = !selectAll;
                          itemSelected = List<bool>.generate(itemList.length, (context) => selectAll);
                        }
                      });
                    },
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListBuilder extends StatefulWidget {
  final List<dynamic> dataList;
  final List<bool> selectedList;
  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;

  const ListBuilder({
    super.key,
    required this.dataList,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  @override
  State<ListBuilder> createState() => ListBuilderState();
}

class ListBuilderState extends State<ListBuilder> {
  void toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedList.length,
      itemBuilder: (context, int index) {
        return ListTile(
          // leading: const Icon(Icons.abc),
          leading: widget.dataList[index] is DirModel
              ? Icon(
                  Icons.folder,
                  size: iconSize,
                  color: Colors.yellow,
                )
              : Icon(
                  Icons.library_books,
                  size: iconSize,
                  color: Colors.grey,
                ),
          title: checkFileType(widget.dataList[index]),
          onTap: () async => toggle(index),
          onLongPress: () async {
            if (!widget.isSelectionMode) {
              setState(() {
                widget.selectedList[index] = true;
              });
              widget.onSelectionChange!(true);
            } else {
              setState(() {
                widget.selectedList[index] = false;
              });
              widget.onSelectionChange!(false);
            }
          },
          trailing: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: 80,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                widget.isSelectionMode
                    ? Checkbox(
                        value: widget.selectedList[index],
                        onChanged: (bool? x) => toggle(index),
                      )
                    : const SizedBox.shrink(),
                widget.isSelectionMode
                    ? itemActions(
                        widget.dataList[index],
                        Icon(Icons.more_vert, size: iconSize, color: iconColor),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GridBuilder extends StatefulWidget {
  final List<dynamic> dataList;
  final List<bool> selectedList;
  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;

  const GridBuilder({
    super.key,
    required this.dataList,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  void toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.selectedList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5.0, // 纵轴间距
        crossAxisSpacing: 5.0, // 横轴间距
        childAspectRatio: 1 / 1, // 宽高比
        crossAxisCount: int.parse((screenSize(context).width / 150).toStringAsFixed(0)), // 横轴元素个数
      ),
      itemBuilder: (context, int index) {
        return InkWell(
          onTap: () async => toggle(index),
          onLongPress: () async {
            if (!widget.isSelectionMode) {
              setState(() {
                widget.selectedList[index] = true;
              });
              widget.onSelectionChange!(true);
            } else {
              setState(() {
                widget.selectedList[index] = false;
              });
              widget.onSelectionChange!(false);
            }
          },
          child: GridTile(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Visibility(
                    visible: widget.isSelectionMode,
                    child: widget.isSelectionMode
                        ? Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              itemActions(widget.dataList[index], Icon(Icons.more_horiz, size: iconSize, color: iconColor)),
                            ],
                          )
                        : const Row(children: []),
                  ),
                  widget.dataList[index] is DirModel
                      ? const Icon(
                          Icons.folder,
                          size: 50,
                          color: Colors.yellow,
                        )
                      : const Icon(
                          Icons.library_books,
                          size: 50,
                          color: Colors.grey,
                        ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Visibility(
                        visible: widget.isSelectionMode,
                        child: widget.isSelectionMode
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(0),
                                height: 5,
                                width: 5,
                                child: Checkbox(onChanged: (bool? x) => toggle(index), value: widget.selectedList[index]),
                              )
                            : const Icon(null),
                      ),
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: 70,
                        child: checkFileType(widget.dataList[index]),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget checkFileType(dynamic data) {
  if (data is DirModel) {
    DirModel dirObj = data;
    return Text(dirObj.dirName, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis);
  }
  if (data is FileModel) {
    FileModel fileObj = data;
    return Text(fileObj.fileName, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis);
  }
  return Text("null", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis);
}

Widget itemActions(dynamic dataList, Icon icon) {
  return PopupMenuButton<void>(
    padding: const EdgeInsets.all(0),
    tooltip: "",
    color: iconColor,
    icon: icon,
    initialValue: null,
    itemBuilder: (context) {
      return <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: Text(
            Lang().rename,
            style: textStyle(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            var data = dataList;
            if (data is DirModel) {
              print(data.dirName);
            }
            if (data is FileModel) {
              print(data.fileName);
            }
          },
        ),
        PopupMenuItem(
          child: Text(
            Lang().details,
            style: textStyle(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            var data = dataList;
            if (data is DirModel) {
              print(data.dirName);
            }
            if (data is FileModel) {
              print(data.fileName);
            }
          },
        ),
      ];
    },
  );
}
