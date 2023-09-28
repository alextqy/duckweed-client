import 'package:flutter/material.dart';
import 'package:app/common/lang.dart';
import 'package:app/common/tools.dart';

import 'package:app/notifier/base_notifier.dart';
import 'package:app/notifier/file_notifier.dart';

import 'package:app/interface/common/show_alert_dialog.dart';
import 'package:app/interface/common/pub_lib.dart';

import 'package:app/model/file_model.dart';

class FileDetails extends StatefulWidget {
  final FileModel data;

  const FileDetails({
    super.key,
    required this.data,
  });

  @override
  State<FileDetails> createState() => FileDetailsState();
}

class FileDetailsState extends State<FileDetails> with TickerProviderStateMixin {
  FileNotifier fileNotifier = FileNotifier();
  TextEditingController textController = TextEditingController();
  TextEditingController outreachIDController = TextEditingController();

  basicListenerFile() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);

    if (fileNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: fileNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    fileNotifier.addListener(basicListenerFile);
    textController.text = widget.data.fileName;
    outreachIDController.text = widget.data.outreachID;
    super.initState();
  }

  @override
  void dispose() {
    fileNotifier.removeListener(basicListenerFile);
    fileNotifier.dispose();
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
            const Expanded(child: SizedBox()),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 200,
              child: TextFormField(
                style: textStyle(),
                controller: textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  icon: Icon(Icons.library_books, size: iconSize, color: Colors.grey),
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
              width: 300,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 200,
                    child: TextButton(
                      child: Text("${Lang().copy} ID", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onPressed: () {
                        copy(widget.data.outreachID);
                        showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 300,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 200,
                    child: TextButton(
                      child: Text("${Lang().copy} MD5", style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onPressed: () {
                        copy(widget.data.md5);
                        showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 200,
              child: Tooltip(
                message: Lang().fileSize,
                textStyle: textStyle(),
                decoration: tooltipStyle(),
                child: Row(
                  children: [
                    Icon(Icons.picture_in_picture_rounded, size: iconSize, color: iconColor),
                    const SizedBox(width: 15),
                    Text(widget.data.fileSize, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 200,
              child: Tooltip(
                message: Lang().fileType,
                textStyle: textStyle(),
                decoration: tooltipStyle(),
                child: Row(
                  children: [
                    Icon(Icons.type_specimen_rounded, size: iconSize, color: iconColor),
                    const SizedBox(width: 15),
                    Text(widget.data.fileType, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
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
                    Icon(Icons.access_time_rounded, size: iconSize, color: iconColor),
                    const SizedBox(width: 15),
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
                    fileNotifier.fileModify(url: appUrl, id: widget.data.id, fileName: textController.text, dirID: widget.data.dirID);
                  }
                },
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
