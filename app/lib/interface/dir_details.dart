import 'package:flutter/material.dart';
import 'package:app/common/lang.dart';
import 'package:app/common/tools.dart';

import 'package:app/notifier/base_notifier.dart';
import 'package:app/notifier/dir_notifier.dart';

import 'package:app/interface/common/show_alert_dialog.dart';
import 'package:app/interface/common/pub_lib.dart';

import 'package:app/model/dir_model.dart';

class DirDetails extends StatefulWidget {
  final DirModel data;

  const DirDetails({
    super.key,
    required this.data,
  });

  @override
  State<DirDetails> createState() => DirDetailsState();
}

class DirDetailsState extends State<DirDetails> with TickerProviderStateMixin {
  DirNotifier dirNotifier = DirNotifier();
  TextEditingController textController = TextEditingController();

  basicListenerDir() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);

    if (dirNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: dirNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    dirNotifier.addListener(basicListenerDir);
    textController.text = widget.data.dirName;
    super.initState();
  }

  @override
  void dispose() {
    dirNotifier.removeListener(basicListenerDir);
    dirNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().details, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 200,
              child: TextFormField(
                style: textStyle(),
                controller: textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  icon: Icon(Icons.folder, size: iconSize, color: Colors.yellow),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                    onPressed: () async => textController.clear(),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 200,
              child: Tooltip(
                message: Lang().createtime,
                textStyle: textStyle(),
                decoration: tooltipStyle(),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: iconSize, color: iconColor),
                    const SizedBox(width: 10),
                    Text(Tools().timestampToStr(widget.data.createtime), style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(0),
              width: 150,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: bgColor(context),
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Center(
                  child: Text("OK", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                onTap: () async {
                  if (textController.text.isNotEmpty) {
                    dirNotifier.dirAction(url: appUrl, dirName: textController.text, parentID: widget.data.parentID, id: widget.data.id);
                  }
                },
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
