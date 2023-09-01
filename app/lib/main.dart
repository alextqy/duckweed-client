import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:app/common/lang.dart";
import "package:app/common/file.dart";
import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/user_notifier.dart";

import "package:app/forgot_password.dart";

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: IndexPage(title: FileHelper().jsonRead(key: "title")),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IndexPage extends StatefulWidget {
  final String title;

  const IndexPage({super.key, required this.title});

  @override
  State<IndexPage> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  int? groupValue = 1;
  int showSpeed = 450;
  double iconSize = 20;
  bool opacityShow0 = false;
  bool opacityShow1 = true;
  bool opacityShow2 = false;
  bool obscureText = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late AnimationController animationController;
  late Animation<double> animationW;

  UserNotifier userNotifier = UserNotifier();

  TextStyle textStyle({Color color = Colors.white70, double fontSize = 15}) {
    return TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: fontSize, textBaseline: TextBaseline.alphabetic);
  }

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: Theme.of(context).colorScheme.inversePrimary, duration: 1);
    if (userNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: Theme.of(context).colorScheme.inversePrimary);
    } else {
      showSnackBar(context, content: userNotifier.operationMemo, backgroundColor: Theme.of(context).colorScheme.inversePrimary);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationW = Tween(begin: 0.0, end: 200.0).animate(animationController);
    animationController.forward();
    userNotifier.addListener(basicListener);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.inversePrimary;

    // Size screenSize = MediaQuery.of(context).size;

    /*
    Drawer actionMenu(BuildContext context) {
      return Drawer(
        width: screenSize.width * 0.45,
        backgroundColor: Colors.black54,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            ListTile(
              horizontalTitleGap: 20,
              leading: const Icon(Icons.search_outlined, size: 20),
              title: Text(
                Lang().forgotPassword,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      );
    }
    */

    return Scaffold(
      // endDrawer: actionMenu(context),
      appBar: AppBar(
        toolbarHeight: 25,
        backgroundColor: bgColor,
        title: Text(widget.title, style: textStyle()),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            networkWidget(),
            signInWidget(),
            signUpWidget(),
            const Expanded(child: SizedBox()),
            CupertinoSlidingSegmentedControl<int>(
              backgroundColor: Colors.white70,
              thumbColor: Colors.black38,
              padding: const EdgeInsets.all(0),
              groupValue: groupValue,
              children: {
                0: groupValue == 0 ? selectedTabFont(Lang().network) : unselectedTabFont(Lang().network),
                1: groupValue == 1 ? selectedTabFont(Lang().signIn) : unselectedTabFont(Lang().signIn),
                2: groupValue == 2 ? selectedTabFont(Lang().signUp) : unselectedTabFont(Lang().signUp),
              },
              onValueChanged: (value) {
                setState(() {
                  groupValue = value;
                  opacityShow0 = groupValue == 0 ? true : false;
                  opacityShow1 = groupValue == 1 ? true : false;
                  opacityShow2 = groupValue == 2 ? true : false;
                  if (groupValue == 1) {
                    animationController.forward();
                  } else {
                    animationController.reset();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  selectedTabFont(String t) {
    return Text(t, style: textStyle());
  }

  unselectedTabFont(String t) {
    return Text(t, style: textStyle(color: Colors.black));
  }

  Widget networkWidget() {
    return AnimatedOpacity(
      opacity: opacityShow0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: showSpeed),
      child: Column(
        children: [
          Visibility(
            visible: opacityShow0,
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInWidget() {
    return AnimatedOpacity(
      opacity: opacityShow1 ? 1.0 : 0.0,
      duration: Duration(milliseconds: showSpeed),
      child: Column(
        children: [
          Visibility(
            visible: opacityShow1,
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 300,
                    child: TextFormField(
                      controller: accountController,
                      maxLines: 1,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                          onPressed: () => accountController.clear(),
                        ),
                        icon: Icon(Icons.account_box, size: iconSize, color: Colors.white70),
                        labelText: Lang().account,
                        labelStyle: textStyle(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      maxLines: 1,
                      obscureText: obscureText,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye, size: iconSize, color: Colors.white70),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        icon: Icon(Icons.lock_open, size: iconSize, color: Colors.white70),
                        labelText: Lang().password,
                        labelStyle: textStyle(),
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
                        TextButton(
                          child: Text(
                            Lang().forgotPassword,
                            style: textStyle(color: Colors.white60, fontSize: 12),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const ForgotPassword();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animationW,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(0),
                        width: animationW.value,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        child: InkWell(
                          child: Center(
                            child: Text("GO", style: textStyle()),
                          ),
                          onTap: () {
                            if (accountController.text != "" && passwordController.text != "") {
                              userNotifier.signIn(
                                account: accountController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpWidget() {
    return AnimatedOpacity(
      opacity: opacityShow2 ? 1.0 : 0.0,
      duration: Duration(milliseconds: showSpeed),
      child: Column(
        children: [
          Visibility(
            visible: opacityShow2,
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
