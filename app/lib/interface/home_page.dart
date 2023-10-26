// ignore_for_file: must_be_immutable

import "dart:convert";

import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:file_selector/file_selector.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/announcement_notifier.dart";
import "package:app/notifier/dir_notifier.dart";
import "package:app/notifier/file_notifier.dart";

import "package:app/interface/common/routes.dart";
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
  List<bool> itemSelected = [];
  bool isSelectionMode = false;
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

  void fetchData({bool gridMode = false}) {
    content.clear();
    itemList.clear();
    itemSelected.clear();
    isSelectionMode = false;
    selectAll = false;
    isGridMode = gridMode;

    fetchAnnouncementData();

    dirNotifier.dirs(url: appUrl, order: order, parentID: parentID, dirName: searchDirName).then((value) {
      setState(() {
        itemList.addAll(DirModel().fromJsonList(jsonEncode(value.data)));
        fileNotifier.files(url: appUrl, order: order, dirID: parentID, fileName: searchFileName).then((value) {
          setState(() {
            itemList.addAll(FileModel().fromJsonList(jsonEncode(value.data)));
            initializeSelection();
          });
        });
      });
    });
  }

  void setParentID(int setParentID) {
    parentID = setParentID;
    fetchData();
  }

  basicListenerDir() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);

    if (dirNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: dirNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  basicListenerFile() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);

    if (fileNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: fileNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  void initializeSelection() {
    itemSelected = List<bool>.generate(itemList.length, (context) => false);
  }

  List<dynamic> checkItemSelected() {
    List<dynamic> dynamicList = [];
    int i = 0;
    for (bool element in itemSelected) {
      if (element) {
        dynamicList.add(itemList[i]);
      }
      i++;
    }
    return dynamicList;
  }

  @override
  void initState() {
    fetchData();
    dirNotifier.addListener(basicListenerDir);
    fileNotifier.addListener(basicListenerFile);
    super.initState();
  }

  @override
  void dispose() {
    dirNotifier.removeListener(basicListenerDir);
    fileNotifier.removeListener(basicListenerFile);
    dirNotifier.dispose();
    fileNotifier.dispose();
    announcementNotifier.dispose();
    itemList.clear();
    itemSelected.clear();
    super.dispose();
  }

  void showActionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.black54,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 230,
          child: Column(
            children: <Widget>[
              Container(
                color: bgColor(context),
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                height: 15,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Row(
                    children: [
                      Expanded(child: SizedBox.shrink()),
                      // Icon(Icons.dehaze, color: iconColor, size: 15),
                      Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // hoverColor: bgColor(context),
                      // splashColor: bgColor(context),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.folder, color: iconColor, size: iconSize),
                            const SizedBox(width: 10),
                            Text(Lang().newFolder, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
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
                                          const Expanded(child: SizedBox.shrink()),
                                          TextButton(
                                            child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            onPressed: () async {
                                              if (textController.text.isNotEmpty) {
                                                dirNotifier.dirAction(url: appUrl, dirName: textController.text, parentID: parentID, id: 0).then((value) {
                                                  if (!value.state) {
                                                    showSnackBar(context, content: Lang().operationFailed, backgroundColor: bgColor(context), duration: 1);
                                                  } else {
                                                    fetchData();
                                                  }
                                                });
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // hoverColor: bgColor(context),
                      // splashColor: bgColor(context),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.upload, color: iconColor, size: iconSize),
                            const SizedBox(width: 10),
                            Text(Lang().uploadFiles, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // hoverColor: bgColor(context),
                      // splashColor: bgColor(context),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.download, color: iconColor, size: iconSize),
                            const SizedBox(width: 10),
                            Text(Lang().downloadFiles, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // hoverColor: bgColor(context),
                      // splashColor: bgColor(context),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.delete, color: Colors.red, size: iconSize),
                            const SizedBox(width: 10),
                            Text(Lang().delete, style: textStyle(fontSize: 18, color: Colors.red), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        if (checkItemSelected().isEmpty) {
                          return;
                        }
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
                                        Navigator.pop(context);
                                        int i = 0;
                                        for (bool element in itemSelected) {
                                          if (element) {
                                            if (itemList[i] is DirModel) {
                                              DirModel obj = itemList[i];
                                              dirNotifier.dirDel(url: appUrl, id: obj.id).then((value) {
                                                if (value.state) {
                                                  fetchData();
                                                }
                                              });
                                            }
                                            if (itemList[i] is FileModel) {
                                              FileModel obj = itemList[i];
                                              fileNotifier.fileDel(url: appUrl, id: obj.id).then((value) {
                                                if (value.state) {
                                                  fetchData();
                                                }
                                              });
                                            }
                                          }
                                          i++;
                                        }
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      // hoverColor: bgColor(context),
                      // splashColor: bgColor(context),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 35,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.keyboard_arrow_down, color: iconColor, size: 35),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                        waitDuration: const Duration(milliseconds: 0),
                        showDuration: const Duration(milliseconds: 0),
                        message: Lang().hideBulletinBoard,
                        textStyle: textStyle(),
                        decoration: tooltipStyle(),
                        child: IconButton(
                          icon: Icon(Icons.close, size: 20, color: iconColor),
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
                        parentWidget: this,
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
                        parentWidget: this,
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
              color: Colors.black,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.menu_open, size: 30, color: iconColor),
                    onPressed: () async => showActionSheet(context),
                  ),
                  if (isGridMode)
                    IconButton(
                      icon: Icon(Icons.widgets, size: 25, color: iconColor),
                      onPressed: () async {
                        setState(() {
                          isGridMode = false;
                        });
                      },
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.view_agenda, size: 25, color: iconColor),
                      onPressed: () async {
                        setState(() {
                          isGridMode = true;
                        });
                      },
                    ),
                  parentID > 0
                      ? IconButton(
                          icon: Icon(Icons.reply, size: 25, color: iconColor),
                          onPressed: () async {
                            dirNotifier.dirInfo(url: appUrl, id: parentID).then((value) {
                              dirNotifier.dirModel = DirModel.fromJson(value.data);
                              setParentID(dirNotifier.dirModel.parentID);
                            });
                          },
                        )
                      : const SizedBox.shrink(),
                  isSelectionMode
                      ? IconButton(
                          icon: Icon(Icons.check_box_outlined, size: 25, color: iconColor),
                          onPressed: () async {
                            setState(() {
                              if (isSelectionMode) {
                                selectAll = !selectAll;
                                itemSelected = List<bool>.generate(itemList.length, (context) => selectAll);
                              }
                            });
                          },
                        )
                      : const SizedBox.shrink(),
                  const Expanded(child: SizedBox.shrink()),
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
  late HomePageState parentWidget;
  late List<dynamic> dataList;
  late List<bool> selectedList;
  late bool isSelectionMode;
  late Function(bool)? onSelectionChange;

  ListBuilder({
    super.key,
    required this.parentWidget,
    required this.dataList,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  @override
  State<ListBuilder> createState() => ListBuilderState();
}

class ListBuilderState extends State<ListBuilder> {
  FileNotifier fileNotifier = FileNotifier();
  DirNotifier dirNotifier = DirNotifier();
  List<dynamic> dataArr = [];

  @override
  void initState() {
    dataArr = widget.dataList;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  Widget checkItem(dynamic dataList, int index) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 15),
          dataList[index] is DirModel
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
          const SizedBox(width: 10),
          SizedBox(width: screenSize(context).width * 0.6, child: checkFileType(dataList[index])),
          const Expanded(child: SizedBox.shrink()),
          widget.isSelectionMode
              ? Checkbox(
                  value: widget.selectedList[index],
                  onChanged: (bool? x) => toggle(index),
                )
              : const SizedBox.shrink(),
          widget.isSelectionMode
              ? IconButton(
                  icon: Icon(Icons.more_vert, size: iconSize, color: iconColor),
                  onPressed: () async {
                    if (dataList[index] is DirModel) {
                      Navigator.of(context).push(RouteHelper().generate(context, "/dir/details", data: dataList[index])).then((value) {
                        setState(() {
                          widget.parentWidget.fetchData();
                        });
                      });
                    }
                    if (dataList[index] is FileModel) {
                      Navigator.of(context).push(RouteHelper().generate(context, "/file/details", data: dataList[index])).then((value) {
                        setState(() {
                          widget.parentWidget.fetchData();
                        });
                      });
                    }
                  },
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Future<bool> move(int destDirID, List<int> dirIDs, List<int> fileIDs) async {
    if (dirIDs.isNotEmpty) {
      String dirIDsStr = dirIDs.join(",");
      await dirNotifier.dirMove(url: appUrl, id: destDirID, ids: dirIDsStr);
    }
    if (fileIDs.isNotEmpty) {
      String fileIDsStr = fileIDs.join(",");
      await fileNotifier.fileMove(url: appUrl, dirID: destDirID, ids: fileIDsStr);
    }
    return Future.delayed(const Duration(milliseconds: 500), () => true);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedList.length,
      itemBuilder: (context, int index) {
        return DragTarget(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Draggable(
              axis: Axis.vertical,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 50,
                  width: screenSize(context).width,
                  child: checkItem(dataArr, index),
                ),
              ),
              data: widget.parentWidget.checkItemSelected().isEmpty ? dataArr[index] : widget.parentWidget.checkItemSelected(),
              child: InkWell(
                // onTap: () async => toggle(index),
                onTap: () async {
                  if (dataArr[index] is DirModel) {
                    DirModel obj = dataArr[index];
                    widget.parentWidget.setParentID(obj.id);
                  }
                },
                onLongPress: () async {
                  if (!widget.isSelectionMode) {
                    setState(() {
                      // widget.selectedList[index] = true;
                    });
                    widget.onSelectionChange!(true);
                  } else {
                    setState(() {
                      // widget.selectedList[index] = false;
                    });
                    widget.onSelectionChange!(false);
                  }
                  widget.parentWidget.initializeSelection();
                },
                child: checkItem(dataArr, index),
              ),
            );
          },
          onAccept: (data) async {
            if (dataArr[index] is FileModel) {
              return;
            }
            DirModel destObj = dataArr[index];

            if (data is FileModel) {
              FileModel fileObj = data;
              fileNotifier.fileMove(url: appUrl, dirID: destObj.id, ids: fileObj.id).then((value) {
                if (value.state) {
                  setState(() {
                    dataArr.clear();
                    widget.parentWidget.fetchData();
                  });
                }
              });
            }
            if (data is DirModel) {
              DirModel dirObj = data;
              if (dirObj.id != destObj.id) {
                dirNotifier.dirMove(url: appUrl, id: destObj.id, ids: dirObj.id).then((value) {
                  if (value.state) {
                    setState(() {
                      dataArr.clear();
                      widget.parentWidget.fetchData();
                    });
                  }
                });
              }
            }
            if (data is List<dynamic>) {
              if (data.contains(dataArr[index]) && dataArr[index] is DirModel) {
                data.remove(dataArr[index]);
              }
              List<int> dirIDs = [];
              List<int> fileIDs = [];
              for (int i = 0; i < data.length; i++) {
                if (data[i] is DirModel) {
                  DirModel obj = data[i];
                  dirIDs.add(obj.id);
                }
                if (data[i] is FileModel) {
                  FileModel obj = data[i];
                  fileIDs.add(obj.id);
                }
              }
              move(destObj.id, dirIDs, fileIDs).then((value) {
                dataArr.clear();
                widget.parentWidget.fetchData();
              });
            }
          },
        );
      },
    );
  }
}

class GridBuilder extends StatefulWidget {
  late HomePageState parentWidget;
  late List<dynamic> dataList;
  late List<bool> selectedList;
  late bool isSelectionMode;
  late Function(bool)? onSelectionChange;

  GridBuilder({
    super.key,
    required this.parentWidget,
    required this.dataList,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  FileNotifier fileNotifier = FileNotifier();
  DirNotifier dirNotifier = DirNotifier();
  List<dynamic> dataArr = [];

  void toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  void initState() {
    dataArr = widget.dataList;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget checkItem(int index) {
    return GridTile(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Visibility(
              visible: widget.isSelectionMode,
              child: widget.isSelectionMode
                  ? Row(
                      children: [
                        const Expanded(child: SizedBox.shrink()),
                        IconButton(
                          icon: Icon(Icons.more_horiz, size: iconSize, color: iconColor),
                          onPressed: () async {
                            if (widget.dataList[index] is DirModel) {
                              Navigator.of(context).push(RouteHelper().generate(context, "/dir/details", data: widget.dataList[index])).then((value) {
                                setState(() {
                                  widget.parentWidget.fetchData();
                                });
                              });
                            }
                            if (widget.dataList[index] is FileModel) {
                              Navigator.of(context).push(RouteHelper().generate(context, "/file/details", data: widget.dataList[index])).then((value) {
                                setState(() {
                                  widget.parentWidget.fetchData();
                                });
                              });
                            }
                          },
                        ),
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
                const Expanded(child: SizedBox.shrink()),
                Visibility(
                  visible: widget.isSelectionMode,
                  child: Expanded(
                    child: widget.isSelectionMode
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: Checkbox(onChanged: (bool? x) => toggle(index), value: widget.selectedList[index]),
                          )
                        : const Icon(null),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    child: checkFileType(widget.dataList[index]),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Future<bool> move(int destDirID, List<int> dirIDs, List<int> fileIDs) async {
    if (dirIDs.isNotEmpty) {
      String dirIDsStr = dirIDs.join(",");
      await dirNotifier.dirMove(url: appUrl, id: destDirID, ids: dirIDsStr);
    }
    if (fileIDs.isNotEmpty) {
      String fileIDsStr = fileIDs.join(",");
      await fileNotifier.fileMove(url: appUrl, dirID: destDirID, ids: fileIDsStr);
    }
    return Future.delayed(const Duration(milliseconds: 500), () => true);
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
        return DragTarget(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Draggable(
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: checkItem(index),
                ),
              ),
              data: widget.parentWidget.checkItemSelected().isEmpty ? widget.dataList[index] : widget.parentWidget.checkItemSelected(),
              child: InkWell(
                // onTap: () async => toggle(index),
                onTap: () async {
                  if (widget.dataList[index] is DirModel) {
                    DirModel obj = widget.dataList[index];
                    widget.parentWidget.setParentID(obj.id);
                  }
                },
                onLongPress: () async {
                  if (!widget.isSelectionMode) {
                    setState(() {
                      // widget.selectedList[index] = true;
                    });
                    widget.onSelectionChange!(true);
                  } else {
                    setState(() {
                      // widget.selectedList[index] = false;
                    });
                    widget.onSelectionChange!(false);
                  }
                  widget.parentWidget.initializeSelection();
                },
                child: checkItem(index),
              ),
            );
          },
          onAccept: (data) async {
            if (dataArr[index] is FileModel) {
              return;
            }
            DirModel destObj = dataArr[index];

            if (data is FileModel) {
              FileModel fileObj = data;
              fileNotifier.fileMove(url: appUrl, dirID: destObj.id, ids: fileObj.id).then((value) {
                if (value.state) {
                  setState(() {
                    dataArr.clear();
                    widget.parentWidget.fetchData(gridMode: true);
                  });
                }
              });
            }
            if (data is DirModel) {
              DirModel dirObj = data;
              if (dirObj.id != destObj.id) {
                dirNotifier.dirMove(url: appUrl, id: destObj.id, ids: dirObj.id).then((value) {
                  if (value.state) {
                    setState(() {
                      dataArr.clear();
                      widget.parentWidget.fetchData(gridMode: true);
                    });
                  }
                });
              }
            }
            if (data is List<dynamic>) {
              if (data.contains(dataArr[index]) && dataArr[index] is DirModel) {
                data.remove(dataArr[index]);
              }
              List<int> dirIDs = [];
              List<int> fileIDs = [];
              for (int i = 0; i < data.length; i++) {
                if (data[i] is DirModel) {
                  DirModel obj = data[i];
                  dirIDs.add(obj.id);
                }
                if (data[i] is FileModel) {
                  FileModel obj = data[i];
                  fileIDs.add(obj.id);
                }
              }
              move(destObj.id, dirIDs, fileIDs).then((value) {
                dataArr.clear();
                widget.parentWidget.fetchData(gridMode: true);
              });
            }
          },
        );
      },
    );
  }
}

Widget checkFileType(dynamic data) {
  if (data is DirModel) {
    DirModel dirObj = data;
    return Tooltip(
      waitDuration: const Duration(milliseconds: 1000),
      showDuration: const Duration(milliseconds: 0),
      textStyle: textStyle(),
      decoration: tooltipStyle(),
      message: dirObj.dirName,
      child: Text(dirObj.dirName, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
  if (data is FileModel) {
    FileModel fileObj = data;
    return Tooltip(
      waitDuration: const Duration(milliseconds: 1000),
      showDuration: const Duration(milliseconds: 0),
      textStyle: textStyle(),
      decoration: tooltipStyle(),
      message: fileObj.fileName,
      child: Text(fileObj.fileName, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
  return Text("null", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis);
}
