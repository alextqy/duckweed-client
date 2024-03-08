// ignore_for_file: must_be_immutable

import "package:app/interface/common/pub_lib.dart";
import "package:flutter/material.dart";

class UploadItem extends StatefulWidget {
  const UploadItem({super.key});

  @override
  State<UploadItem> createState() => UploadItemState();
}

class UploadItemState extends State<UploadItem> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      height: 65,
      width: screenSize(context).width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((10.0)),
        border: Border.all(color: Colors.white70, width: 3),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(
            backgroundColor: Colors.white70,
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Tooltip(
              message: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
              textStyle: textStyle(),
              decoration: tooltipStyle(),
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Text(
                  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                  style: textStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: IconButton(
              icon: Icon(Icons.more_vert, color: iconColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
