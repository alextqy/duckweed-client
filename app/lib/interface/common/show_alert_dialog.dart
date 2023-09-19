import "package:app/interface/common/pub_lib.dart";
import "package:flutter/material.dart";
import "package:app/common/lang.dart";

// 提示框
showAlertDialog(BuildContext context, {String memo = ""}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, Function state) {
          return AlertDialog(
            title: Text(Lang().title, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
            content: Text(memo, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(Lang().cancel, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          );
        },
      );
    },
  );
}

// 控件框
showAlertWidget(BuildContext context, Widget child) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return UnconstrainedBox(
        constrainedAxis: Axis.vertical, // 取消原有宽高限制
        child: StatefulBuilder(
          builder: (BuildContext context, Function state) {
            return Dialog(
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: child,
              ),
            );
          },
        ),
      );
    },
  );
}

ScaffoldFeatureController showSnackBar(BuildContext context, {String content = "", Color backgroundColor = Colors.black, int duration = 2}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(10),
      content: Text(content, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      // action: SnackBarAction(label: "Action", onPressed: () async {}),
    ),
  );
}
