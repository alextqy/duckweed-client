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
  bool sendMail = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController newAccountController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newCaptchaController = TextEditingController();

  late AnimationController animationControlle0;
  late AnimationController animationControlle1;
  late AnimationController animationControlle2;
  late AnimationController animationControlleEmail;
  late Animation<double> animation0;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animationEmail;

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
    animationControlle0 = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationControlle1 = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationControlle2 = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationControlleEmail = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animation0 = Tween(begin: 200.0, end: 0.0).animate(animationControlle0);
    animation1 = Tween(begin: 0.0, end: 200.0).animate(animationControlle1);
    animation2 = Tween(begin: 150.0, end: 0.0).animate(animationControlle2);
    animationEmail = Tween(begin: 20.0, end: 0.0).animate(animationControlleEmail);

    animationControlle0.forward();
    animationControlle1.forward();
    animationControlle2.forward();
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
                  accountController.clear();
                  passwordController.clear();

                  newAccountController.clear();
                  newNameController.clear();
                  newPasswordController.clear();
                  newEmailController.clear();
                  newCaptchaController.clear();

                  groupValue = value;
                  opacityShow0 = groupValue == 0 ? true : false;
                  opacityShow1 = groupValue == 1 ? true : false;
                  opacityShow2 = groupValue == 2 ? true : false;

                  if (groupValue == 0) {
                    animationControlle0.forward();
                  } else {
                    animationControlle0.reset();
                  }
                  if (groupValue == 1) {
                    animationControlle1.forward();
                  } else {
                    animationControlle1.reset();
                  }
                  if (groupValue == 2) {
                    animationControlle2.reset();
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

  // 发送邮件动效
  void playAnimationEmail() async {
    try {
      if (newEmailController.text != "") {
        sendMail = false;
        await animationControlleEmail.forward().orCancel;
        await animationControlleEmail.reverse().orCancel;
        Future.delayed(const Duration(milliseconds: 2000)).then((value) async {
          userNotifier.sendEmailSignUp(email: newEmailController.text);
          if (userNotifier.operationStatus.value == OperationStatus.success) {}
          sendMail = true;
        });
      }
    } on TickerCanceled {
      return;
    }
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
                    animation: animation1,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(0),
                        width: animation1.value,
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
    String btnContent = "OK";
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
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: animationEmail,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(0),
                        width: 250,
                        child: TextFormField(
                          controller: newEmailController,
                          maxLines: 1,
                          cursorHeight: 20,
                          cursorWidth: 1,
                          textAlign: TextAlign.center,
                          style: textStyle(),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send, size: animationEmail.value, color: Colors.white70),
                              onPressed: () {
                                if (sendMail == true) {
                                  playAnimationEmail();
                                }
                              },
                            ),
                            icon: Icon(Icons.mail, size: iconSize, color: Colors.white70),
                            hintText: Lang().email,
                            hintStyle: textStyle(),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 250,
                    child: TextFormField(
                      controller: newCaptchaController,
                      maxLines: 1,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                          onPressed: () => newCaptchaController.clear(),
                        ),
                        icon: Icon(Icons.verified, size: iconSize, color: Colors.white70),
                        hintText: Lang().captcha,
                        hintStyle: textStyle(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 250,
                    child: TextFormField(
                      controller: newAccountController,
                      maxLines: 1,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                          onPressed: () => newAccountController.clear(),
                        ),
                        icon: Icon(Icons.account_box, size: iconSize, color: Colors.white70),
                        hintText: Lang().account,
                        hintStyle: textStyle(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 250,
                    child: TextFormField(
                      controller: newNameController,
                      maxLines: 1,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                          onPressed: () => newNameController.clear(),
                        ),
                        icon: Icon(Icons.person, size: iconSize, color: Colors.white70),
                        hintText: Lang().nickName,
                        hintStyle: textStyle(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(0),
                    width: 250,
                    child: TextFormField(
                      controller: newPasswordController,
                      maxLines: 1,
                      obscureText: true,
                      cursorHeight: 20,
                      cursorWidth: 1,
                      textAlign: TextAlign.center,
                      style: textStyle(),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                          onPressed: () => newPasswordController.clear(),
                        ),
                        icon: Icon(Icons.password, size: iconSize, color: Colors.white70),
                        hintText: Lang().password,
                        hintStyle: textStyle(),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animation2,
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(0),
                        width: animation2.value,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        child: InkWell(
                          child: Center(
                            child: Text(btnContent, style: textStyle()),
                          ),
                          onTap: () {
                            if (newEmailController.text != "" && newCaptchaController.text != "" && newAccountController.text != "" && newNameController.text != "" && newPasswordController.text != "") {
                              userNotifier.signUp(account: newAccountController.text, name: newNameController.text, password: newPasswordController.text, email: newEmailController.text, captcha: newCaptchaController.text);
                              if (userNotifier.result.state == true) {
                                newAccountController.clear();
                                newNameController.clear();
                                newPasswordController.clear();
                                newEmailController.clear();
                                newCaptchaController.clear();

                                btnContent = "";
                                animationControlle2.forward();
                              }
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
}
