// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";

import "package:app/common/lang.dart";

import "package:app/interface/common/menu.dart";
import "package:app/interface/common/pub_lib.dart";

import "package:app/interface/upload_item.dart";

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> with TickerProviderStateMixin {
  List<UploadItem> uploadItemList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<UploadItem> fetchData() {
    UploadItem uploadItem1 = const UploadItem();
    UploadItem uploadItem2 = const UploadItem();
    UploadItem uploadItem3 = const UploadItem();
    uploadItemList.add(uploadItem1);
    uploadItemList.add(uploadItem2);
    uploadItemList.add(uploadItem3);
    return uploadItemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: actionMenu(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().uploading, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: Column(children: uploadItemList),
      ),
    );
  }
}
