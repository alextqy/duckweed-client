import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:app/common/lang.dart";
import "package:file_selector/file_selector.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/announcement_notifier.dart";
import "package:app/notifier/dir_notifier.dart";

import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/marquee.dart";

import "package:app/model/announcement_model.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> content = [];

  bool isSelectionMode = false;
  final int listLength = 15;
  late List<bool> selected;
  bool selectAll = false;
  bool isGridMode = false;

  AnnouncementNotifier announcementNotifier = AnnouncementNotifier();
  DirNotifier dirNotifier = DirNotifier();

  bool showMarquee = true;
  int parentID = 0;

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

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (dirNotifier.operationStatus.value == OperationStatus.success) {
      // fetchData();
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: dirNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    fetchAnnouncementData();
    dirNotifier.addListener(basicListener);
    initializeSelection();
    super.initState();
  }

  @override
  void dispose() {
    dirNotifier.removeListener(basicListener);
    dirNotifier.dispose();
    selected.clear();
    super.dispose();
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(Lang().newFolder, style: textStyle(fontSize: 18)),
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
                                  child: Text("OK", style: textStyle()),
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
            child: Text(Lang().uploadFiles, style: textStyle(fontSize: 18)),
            onPressed: () async {
              fileSelector(["*"]).then((value) {
                if (value.isNotEmpty) {
                  for (XFile f in value) {
                    print(f.path);
                  }
                }
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void initializeSelection() {
    selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    print(selected);
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
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(child: Marquee(data: content, url: "/announcement/get")),
                    SizedBox(
                      width: 45,
                      child: Tooltip(
                        message: Lang().hideBulletinBoard,
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
                alignment: Alignment.center,
                child: isGridMode
                    ? GridBuilder(
                        isSelectionMode: isSelectionMode,
                        selectedList: selected,
                        onSelectionChange: (bool x) {
                          setState(() {
                            isSelectionMode = x;
                          });
                        },
                      )
                    : ListBuilder(
                        isSelectionMode: isSelectionMode,
                        selectedList: selected,
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
                      selectAll = !selectAll;
                      setState(() {
                        selected = List<bool>.generate(listLength, (_) => selectAll);
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
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  void _toggle(int index) {
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
        itemBuilder: (_, int index) {
          return ListTile(
              onTap: () => _toggle(index),
              onLongPress: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    widget.selectedList[index] = true;
                  });
                  widget.onSelectionChange!(true);
                }
              },
              trailing: widget.isSelectionMode
                  ? Checkbox(
                      value: widget.selectedList[index],
                      onChanged: (bool? x) => _toggle(index),
                    )
                  : const SizedBox.shrink(),
              title: Text('item $index'));
        });
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;
  final List<bool> selectedList;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.selectedList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int index) {
          return InkWell(
            onTap: () => _toggle(index),
            onLongPress: () {
              if (!widget.isSelectionMode) {
                setState(() {
                  widget.selectedList[index] = true;
                });
                widget.onSelectionChange!(true);
              }
            },
            child: GridTile(
                child: Container(
              child: widget.isSelectionMode ? Checkbox(onChanged: (bool? x) => _toggle(index), value: widget.selectedList[index]) : const Icon(Icons.image),
            )),
          );
        });
  }
}
