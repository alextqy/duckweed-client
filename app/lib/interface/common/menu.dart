import "package:app/main.dart";
import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/common/file.dart";
import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/routes.dart";

Drawer actionMenu(BuildContext context) {
  dynamic menuHeader(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        // decoration: const BoxDecoration(color: Colors.black12),
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            SizedBox(
              height: 58,
              width: 58,
              child: InkWell(
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    height: 53,
                    width: 53,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(appAccount.substring(0, 2), style: textStyle(fontSize: 24)),
                    ),
                  ),
                ),
                onTap: () {
                  // Navigator.of(context).push(RouteHelper().generate("", headline: headline));
                },
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  dynamic menuFooter(BuildContext context) {
    return Tooltip(
      message: Lang().longPressToExit,
      textStyle: textStyle(),
      decoration: const BoxDecoration(color: Colors.black),
      child: SizedBox(
        height: 35,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return bgColor(context);
            }),
          ),
          child: Row(
            children: [
              const Text("v 0.1.0"),
              const Expanded(child: SizedBox()),
              Text(Lang().exit),
              const SizedBox(width: 10),
              const Icon(size: 18, Icons.exit_to_app),
            ],
          ),
          onLongPress: () {
            // try {
            //   .then((value) {
            //     if (value.state == true) {
            //       if (FileHelper().delFile("token")) {
            //         exit(0);
            //       }
            //     } else {
            //       Toast().show(context, message: value.memo);
            //     }
            //   });
            // } catch (e) {
            //   Toast().show(context, message: e.toString());
            // }
          },
          onPressed: () {
            // try {
            //   .then((value) {
            //     if (value.state == true) {
            //       if (FileHelper().delFile("token")) {
            //         // 返回到首页并清理路由节点
            //         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => IndexPage(title: appTitle)), (Route<dynamic> route) {
            //           return route.isFirst;
            //         });
            //       }
            //     } else {
            //       Toast().show(context, message: value.message);
            //     }
            //   });
            // } catch (e) {
            //   Toast().show(context, message: e.toString());
            // }
          },
        ),
      ),
    );
  }

  return Drawer(
    width: screenSize(context).width * 0.3,
    backgroundColor: Colors.black54,
    child: Column(
      children: [
        menuHeader(context),
        const Expanded(child: SizedBox()),
        // ListTile(
        //   horizontalTitleGap: 20,
        //   leading: const Icon(Icons.),
        //   title: Text("...", style: textStyle()),
        //   onTap: () async {
        //     Navigator.of(context).push(RouteHelper().generate(context, "/"));
        //   },
        // ),
        const Expanded(child: SizedBox()),
        menuFooter(context),
      ],
    ),
  );
}
