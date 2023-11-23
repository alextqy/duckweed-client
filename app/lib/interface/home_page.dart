// ignore_for_file: must_be_immutable

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:file_selector/file_selector.dart";

import "package:app/common/lang.dart";
import "package:app/common/file.dart";

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
import "package:app/model/original_file_model.dart";

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
  bool showMarquee = false;
  int order = -1;
  int parentID = 0;
  String searchName = "";
  int status = 0;
  bool showParentDir = false;
  String parentDirName = "";

  AnnouncementNotifier announcementNotifier = AnnouncementNotifier();
  DirNotifier dirNotifier = DirNotifier();
  FileNotifier fileNotifier = FileNotifier();

  TextEditingController searchController = TextEditingController();

  late AnimationController searchAnimationController;
  late Animation<double> searchAnimation;

  void fetchAnnouncementData() {
    announcementNotifier.announcements(url: appUrl).then((value) {
      setState(() {
        announcementNotifier.announcementListModel = AnnouncementModel().fromJsonList(jsonEncode(value.data));
        for (AnnouncementModel a in announcementNotifier.announcementListModel) {
          content.add(a.content);
          if (content.isNotEmpty) {
            showMarquee = true;
          }
        }
      });
    });
  }

  void fetchData({bool gridMode = false, bool selectionMode = false}) async {
    content.clear();
    itemList.clear();
    itemSelected.clear();
    isSelectionMode = selectionMode;
    selectAll = false;
    isGridMode = gridMode;

    fetchAnnouncementData();

    await dirNotifier.dirs(url: appUrl, order: order, parentID: parentID, dirName: searchName).then((value) {
      setState(() {
        if (parentID > 0) {
          showParentDir = true;
        } else {
          showParentDir = false;
        }
        itemList.addAll(DirModel().fromJsonList(jsonEncode(value.data)));
      });
    });

    await fileNotifier.files(url: appUrl, order: order, dirID: parentID, fileName: searchName, status: status).then((value) {
      setState(() {
        itemList.addAll(FileModel().fromJsonList(jsonEncode(value.data)));
        initializeSelection();
      });
    });
  }

  void setParentID(int setParentID) async {
    parentID = setParentID;
    if (setParentID > 0) {
      dirNotifier.dirInfo(url: appUrl, id: parentID).then((value) {
        if (value.state) {
          DirModel dirInfo = DirModel.fromJson(value.data);
          parentDirName = dirInfo.dirName;
        }
      });
    } else {
      parentDirName = "";
    }
    fetchData(gridMode: isGridMode);
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

  void snackBar(String content, int duration) {
    showSnackBar(context, content: content, backgroundColor: bgColor(context), duration: duration);
  }

  /// 同步上传信息
  void syncUploadInfo() async {
    if (FileHelper().jsonRead(key: "account").isNotEmpty) {
      await fileNotifier.files(url: appUrl, order: -1, fileName: "", dirID: -1, status: 1).then((value) {
        if (value.state) {
          List<FileModel> uploadFiles = [];
          uploadFiles.addAll(FileModel().fromJsonList(jsonEncode(value.data)));
          if (uploadFiles.isNotEmpty) {
            List<OriginalFileModel> originalFileList = [];
            for (FileModel element in uploadFiles) {
              OriginalFileModel originalFile = OriginalFileModel();
              originalFile.fileName = element.fileName;
              originalFile.fileType = element.fileType;
              originalFile.fileSize = element.fileSize;
              originalFile.md5 = element.md5;
              originalFile.dirID = element.dirID;
              originalFileList.add(originalFile);
            }
            FileHelper().writeFileAsync(appRoot() + uploadQueue(), jsonEncode(originalFileList)).then((value) {
              if (!value) {
                showSnackBar(context, content: Lang().failedToSynchronizeTheUploadedData, backgroundColor: bgColor(context), duration: 1);
              }
            });
          }
        }
      });
    }
  }

  /// 同步下载信息
  void syncDownloadInfo() {}

  @override
  void initState() {
    fetchData();
    dirNotifier.addListener(basicListenerDir);
    fileNotifier.addListener(basicListenerFile);

    searchAnimationController = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    searchAnimation = Tween(begin: 0.0, end: 40.0).animate(searchAnimationController);

    syncUploadInfo();
    syncDownloadInfo();

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
          height: 275,
          child: Column(
            children: <Widget>[
              /// 顶部占位条
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

              /// 添加文件夹
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
                            Icon(Icons.create_new_folder, color: iconColor, size: 25),
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

              /// 上传
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
                            Icon(Icons.upload, color: iconColor, size: 25),
                            const SizedBox(width: 10),
                            Text(Lang().uploadFiles, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        fileSelector(["*"]).then((value) async {
                          if (value.isNotEmpty) {
                            snackBar(Lang().parsingDoNotClose, 2);
                            List<Map<String, dynamic>> fileUploadQueue = [];
                            for (XFile f in value) {
                              await FileHelper.cryptoAsyncMD5(File(f.path)).then((value) async {
                                List<String> fileNameArr = f.name.split(".");
                                String fileType = fileNameArr.last;
                                fileNameArr.remove(fileType);
                                String fileName = fileNameArr.join(".");
                                File file = File(f.path);
                                String fileSize = file.lengthSync().toString();
                                String md5 = value;

                                await fileNotifier
                                    .fileAdd(
                                  url: appUrl,
                                  fileName: fileName,
                                  fileType: fileType,
                                  fileSize: fileSize,
                                  md5: md5,
                                  dirID: parentID,
                                )
                                    .then((value) async {
                                  if (value.state) {
                                    fileUploadQueue.add({
                                      "fileName": fileName,
                                      "fileType": fileType,
                                      "fileSize": fileSize,
                                      "md5": md5,
                                      "parentID": parentID,
                                    });
                                  }
                                });
                              });
                            }

                            if (fileUploadQueue.isNotEmpty) {
                              String fileContent = FileHelper().readFile(appRoot() + uploadQueue());
                              if (fileContent.isEmpty) {
                                await FileHelper().writeFileAsync(appRoot() + uploadQueue(), jsonEncode(fileUploadQueue));
                              } else {
                                List<dynamic> queueContent = jsonDecode(fileContent);
                                queueContent.addAll(fileUploadQueue);
                                await FileHelper().writeFileAsync(appRoot() + uploadQueue(), jsonEncode(queueContent));
                              }
                              fetchData(gridMode: isGridMode);
                              snackBar(Lang().theFilesHaveBeenAddedToTheUploadList, 3);
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              /// 下载
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
                            Icon(Icons.download, color: iconColor, size: 25),
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

              /// 移动
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.center,
                        height: 45,
                        child: Row(
                          children: [
                            const Expanded(child: SizedBox.shrink()),
                            Icon(Icons.drive_file_move, color: iconColor, size: 25),
                            const SizedBox(width: 10),
                            Text(Lang().move, style: textStyle(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        List<dynamic> selectedItems = checkItemSelected();
                        if (selectedItems.isNotEmpty) {
                          Navigator.of(context).push(RouteHelper().generate(context, "/file/move", data: selectedItems)).then((value) {
                            setState(() {
                              fetchData(gridMode: isGridMode, selectionMode: true);
                            });
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              /// 删除
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
                            const Icon(Icons.delete, color: Colors.red, size: 25),
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
                                              await dirNotifier.dirDel(url: appUrl, id: obj.id);
                                            }
                                            if (itemList[i] is FileModel) {
                                              FileModel obj = itemList[i];
                                              await fileNotifier.fileDel(url: appUrl, id: obj.id).then((value) {
                                                print(value.message);
                                              });
                                            }
                                          }
                                          i++;
                                        }
                                        fetchData(gridMode: isGridMode);
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

              /// 关闭
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
            // Visibility(
            //   visible: showMarquee,
            //   child: Container(
            //     margin: const EdgeInsets.all(0),
            //     padding: const EdgeInsets.all(0),
            //     color: Colors.white70,
            //     height: 1,
            //   ),
            // ),
            Visibility(
              visible: showParentDir,
              child: Container(
                color: Colors.white60,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: Text(parentDirName, style: textStyle(color: Colors.black87, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
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
            AnimatedBuilder(
              animation: searchAnimation,
              builder: (context, child) {
                return Container(
                  color: Colors.black,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  height: searchAnimation.value,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: textStyle(),
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.search, size: iconSize, color: iconColor),
                                      onPressed: () async {
                                        if (searchController.text.isNotEmpty) {
                                          status = 0;
                                          searchName = searchController.text;
                                          fetchData(gridMode: isGridMode);
                                        }
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                                      onPressed: () async {
                                        if (searchController.text.isNotEmpty) {
                                          searchController.clear();
                                          status = 0;
                                          searchName = "";
                                          fetchData(gridMode: isGridMode);
                                        }
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: Lang().search,
                                    hintStyle: textStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox.shrink()),
                              Expanded(
                                child: TextButton(
                                  child: Text(Lang().undone, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  onPressed: () async {
                                    status = 1;
                                    fetchData();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  child: Text(Lang().normal, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  onPressed: () async {
                                    status = 2;
                                    fetchData();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  child: Text(Lang().error, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  onPressed: () async {
                                    status = 3;
                                    fetchData();
                                  },
                                ),
                              ),
                              const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ),
                      ),
                      */
                    ],
                  ),
                );
              },
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
                    icon: Icon(Icons.filter_center_focus, size: 25, color: iconColor),
                    onPressed: () async {
                      setState(() {
                        searchName = "";
                        status = 0;
                        searchController.clear();
                        if (searchAnimation.value == 0) {
                          searchAnimationController.forward().orCancel;
                        } else if (searchAnimation.value == 40) {
                          searchAnimationController.reverse().orCancel;
                        } else {
                          return;
                        }
                      });
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.menu_open, size: 30, color: iconColor),
                    onPressed: () async {
                      if (searchAnimation.value == 40) {
                        searchAnimationController.reverse().orCancel;
                      }
                      showActionSheet(context);
                    },
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
                              DirModel dirInfo = DirModel.fromJson(value.data);
                              setParentID(dirInfo.parentID);
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
          checkFileStatusList(dataList[index]),
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
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 5.0, color: Colors.transparent),
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
                onTap: () async {
                  if (dataArr[index] is DirModel) {
                    if (!widget.isSelectionMode) {
                      DirModel obj = dataArr[index];
                      widget.parentWidget.setParentID(obj.id);
                    } else {
                      toggle(index);
                    }
                  } else {
                    if (widget.isSelectionMode) {
                      toggle(index);
                    }
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
            if (dataArr[index] is! DirModel) {
              return;
            }

            if (dataArr[index] is DirModel && data is DirModel) {
              DirModel destObj = dataArr[index];
              DirModel dirObj = data;
              if (destObj.id == dirObj.id) {
                return;
              }
            }

            if (dataArr[index] is DirModel && data is List<dynamic>) {
              if (data.contains(dataArr[index])) {
                return;
              }
            }

            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, Function state) {
                    return AlertDialog(
                      content: Text("${Lang().move}?", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            DirModel destObj = dataArr[index];

                            if (data is FileModel) {
                              FileModel fileObj = data;
                              fileNotifier.fileMove(url: appUrl, dirID: destObj.id, ids: fileObj.id).then((value) {
                                if (value.state) {
                                  setState(() {
                                    dataArr.clear();
                                    widget.parentWidget.fetchData();
                                    // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
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
                                      // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
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
                                // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
                              });
                            }
                            Navigator.pop(context);
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
            Visibility(
              visible: widget.isSelectionMode,
              child: widget.isSelectionMode
                  ? Row(
                      children: [
                        Expanded(
                          child: widget.isSelectionMode
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: Checkbox(onChanged: (bool? x) => toggle(index), value: widget.selectedList[index]),
                                )
                              : const Icon(null),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.more_horiz, size: iconSize, color: iconColor),
                            onPressed: () async {
                              if (widget.dataList[index] is DirModel) {
                                Navigator.of(context).push(RouteHelper().generate(context, "/dir/details", data: widget.dataList[index])).then((value) {
                                  setState(() {
                                    widget.parentWidget.fetchData(gridMode: true);
                                  });
                                });
                              }
                              if (widget.dataList[index] is FileModel) {
                                Navigator.of(context).push(RouteHelper().generate(context, "/file/details", data: widget.dataList[index])).then((value) {
                                  setState(() {
                                    widget.parentWidget.fetchData(gridMode: true);
                                  });
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : const Row(children: []),
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
                onTap: () async {
                  if (dataArr[index] is DirModel) {
                    if (!widget.isSelectionMode) {
                      DirModel obj = dataArr[index];
                      widget.parentWidget.setParentID(obj.id);
                    } else {
                      toggle(index);
                    }
                  } else {
                    if (widget.isSelectionMode) {
                      toggle(index);
                    }
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      // left: BorderSide(color: Colors.red, width: 1),
                      // top: BorderSide(color: Colors.blue, width: 1),
                      // right: BorderSide(color: Colors.orange, width: 1),
                      // bottom: BorderSide(color: Colors.green, width: 1),
                      bottom: BorderSide(color: checkFileStatusGrid(dataArr[index]), width: 3),
                    ),
                    // border: Border.all(width: 1.5, color: checkFileStatusGrid(dataArr[index])),
                    // borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  ),
                  child: checkItem(index),
                ),
              ),
            );
          },
          onAccept: (data) async {
            if (dataArr[index] is! DirModel) {
              return;
            }

            if (dataArr[index] is DirModel && data is DirModel) {
              DirModel destObj = dataArr[index];
              DirModel dirObj = data;
              if (destObj.id == dirObj.id) {
                return;
              }
            }

            if (dataArr[index] is DirModel && data is List<dynamic>) {
              if (data.contains(dataArr[index])) {
                return;
              }
            }

            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, Function state) {
                    return AlertDialog(
                      content: Text("${Lang().move}?", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            DirModel destObj = dataArr[index];

                            if (data is FileModel) {
                              FileModel fileObj = data;
                              fileNotifier.fileMove(url: appUrl, dirID: destObj.id, ids: fileObj.id).then((value) {
                                if (value.state) {
                                  setState(() {
                                    dataArr.clear();
                                    widget.parentWidget.fetchData(gridMode: true);
                                    // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
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
                                      // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
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
                                // showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context), duration: 1);
                              });
                            }
                            Navigator.pop(context);
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
        );
      },
    );
  }
}

Color checkFileStatusGrid(dynamic data) {
  if (data is FileModel) {
    FileModel fileObj = data;
    switch (fileObj.status) {
      case 1:
        return Colors.lightGreenAccent;
      case 2:
        return Colors.transparent;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.transparent;
    }
  } else {
    return Colors.transparent;
  }
}

Widget checkFileStatusList(dynamic data) {
  if (data is FileModel) {
    FileModel fileObj = data;
    switch (fileObj.status) {
      case 1:
        return Icon(Icons.upload, size: iconSize, color: Colors.lightGreenAccent);
      case 2:
        return const SizedBox.shrink();
      case 3:
        return Icon(Icons.error, size: iconSize, color: Colors.redAccent);
      default:
        return const SizedBox.shrink();
    }
  } else {
    return const SizedBox.shrink();
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
