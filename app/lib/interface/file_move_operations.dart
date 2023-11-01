// ignore_for_file: must_be_immutable

import "dart:convert";

import "package:flutter/material.dart";
import "package:app/model/dir_model.dart";
import "package:app/notifier/dir_notifier.dart";
import "package:app/notifier/file_notifier.dart";

import "package:app/common/lang.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/show_alert_dialog.dart";

class FileMoveOperations extends StatefulWidget {
  List<dynamic> data = [];
  FileMoveOperations({super.key, required this.data});

  @override
  State<FileMoveOperations> createState() => FileMoveOperationsState();
}

class FileMoveOperationsState extends State<FileMoveOperations> with TickerProviderStateMixin {
  DirNotifier dirNotifier = DirNotifier();
  FileNotifier fileNotifier = FileNotifier();
  late AnimationController newDirAnimationController;
  late Animation<double> newDirAnimation;
  TextEditingController newFolderController = TextEditingController();

  List<DirModel> dirs = [];
  int currentParentID = 0;
  bool showCheck = false;
  bool showReply = false;

  fetchData({int parentID = 0}) {
    dirNotifier.dirs(url: appUrl, order: -1, parentID: parentID, dirName: "").then((value) {
      setState(() {
        if (parentID > 0) {
          showReply = true;
        } else {
          showReply = false;
        }
        dirs = DirModel().fromJsonList(jsonEncode(value.data));
        List<int> dirIDList = [];
        for (var element in widget.data) {
          if (element is DirModel) {
            dirIDList.add(element.id);
          }
        }
        dirs.removeWhere((element) => dirIDList.contains(element.id));
      });
    });
  }

  @override
  void initState() {
    fetchData(parentID: currentParentID);
    newDirAnimationController = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    newDirAnimation = Tween(begin: 0.0, end: 45.0).animate(newDirAnimationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().move, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          Visibility(
            visible: showReply,
            child: IconButton(
              icon: const Icon(Icons.reply),
              tooltip: Lang().moveUp,
              onPressed: () {
                if (currentParentID > 0) {
                  dirNotifier.dirInfo(url: appUrl, id: currentParentID).then((value) {
                    DirModel dirInfo = DirModel.fromJson(value.data);
                    currentParentID = dirInfo.parentID;
                    fetchData(parentID: dirInfo.parentID);
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dirs.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder,
                            size: iconSize,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Tooltip(
                              waitDuration: const Duration(milliseconds: 1000),
                              showDuration: const Duration(milliseconds: 0),
                              textStyle: textStyle(),
                              decoration: tooltipStyle(),
                              message: dirs[index].dirName,
                              child: Text(dirs[index].dirName, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        currentParentID = dirs[index].id;
                        fetchData(parentID: currentParentID);
                      });
                    },
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: newDirAnimation,
              builder: (context, child) {
                return Container(
                  height: newDirAnimation.value,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  child: TextField(
                    controller: newFolderController,
                    // cursorHeight: 18,
                    // cursorWidth: 2,
                    maxLines: 1,
                    style: textStyle(),
                    decoration: InputDecoration(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      // isCollapsed: true,
                      border: InputBorder.none,
                      filled: true,
                      suffixIcon: Visibility(
                        visible: showCheck,
                        child: IconButton(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(Icons.check, size: iconSize, color: iconColor),
                          onPressed: () async {
                            if (newFolderController.text.isNotEmpty) {
                              dirNotifier.dirAction(url: appUrl, dirName: newFolderController.text, parentID: currentParentID, id: 0).then((value) {
                                if (!value.state) {
                                  showSnackBar(context, content: Lang().operationFailed, backgroundColor: bgColor(context), duration: 1);
                                } else {
                                  newFolderController.clear();
                                  showCheck = false;
                                  newDirAnimationController.reverse().orCancel;
                                  fetchData(parentID: currentParentID);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      child: Text(Lang().newFolder, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onPressed: () async {
                        if (newDirAnimation.value == 0) {
                          newFolderController.clear();
                          newDirAnimationController.forward().orCancel.then((value) => showCheck = true);
                        } else if (newDirAnimation.value == 45) {
                          newFolderController.clear();
                          showCheck = false;
                          newDirAnimationController.reverse().orCancel;
                        } else {
                          return;
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      child: Text(Lang().moveHere, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onPressed: () async {
                        print(currentParentID);
                        print(widget.data);
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
