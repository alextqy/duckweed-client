import "package:flutter/material.dart";
import "package:app/common/lang.dart";

import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/user_notifier.dart";

import "package:app/interface/common/pub_lib.dart";
import "package:app/interface/common/show_alert_dialog.dart";

import "package:app/model/user_model.dart";

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({super.key});

  @override
  State<PersonalSettings> createState() => PersonalSettingsState();
}

class PersonalSettingsState extends State<PersonalSettings> with TickerProviderStateMixin {
  late AnimationController animationControllerEmail;
  late Animation<double> animationEmail;
  late AnimationController animationControllerInput;
  late Animation<double> animationInput;

  bool sendStatus = false;
  bool showCaptcha = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController captchaController = TextEditingController();

  UserNotifier userNotifier = UserNotifier();

  basicListener() async {
    showSnackBar(context, content: Lang().loading, backgroundColor: bgColor(context), duration: 1);
    if (userNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().complete, backgroundColor: bgColor(context));
    } else {
      showSnackBar(context, content: userNotifier.operationMemo, backgroundColor: bgColor(context));
    }
  }

  @override
  void initState() {
    userNotifier.addListener(basicListener);

    emailController.text = "";
    nameController.text = "";
    passwordController.text = "";

    userNotifier.checkPersonalData(url: appUrl).then((value) {
      if (value.state) {
        userNotifier.userModel = UserModel.fromJson(value.data);
        emailController.text = userNotifier.userModel.email;
        nameController.text = userNotifier.userModel.name;
      }
    });

    animationControllerEmail = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationEmail = Tween(begin: 0.0, end: 20.0).animate(animationControllerEmail);
    animationControllerInput = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationInput = Tween(begin: 0.0, end: 64.5).animate(animationControllerInput);

    super.initState();
  }

  @override
  void dispose() {
    userNotifier.removeListener(basicListener);
    userNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().personalSettings, style: textStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
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
              width: 300,
              child: TextFormField(
                controller: nameController,
                maxLines: 1,
                cursorHeight: 20,
                cursorWidth: 1,
                textAlign: TextAlign.center,
                style: textStyle(),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                    onPressed: () async => nameController.clear(),
                  ),
                  icon: Icon(Icons.person, size: iconSize, color: iconColor),
                  labelText: Lang().nickName,
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
                cursorHeight: 20,
                cursorWidth: 1,
                obscureText: true,
                textAlign: TextAlign.center,
                style: textStyle(),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                    onPressed: () async => passwordController.clear(),
                  ),
                  icon: Icon(Icons.password, size: iconSize, color: iconColor),
                  labelText: Lang().newPassword,
                  labelStyle: textStyle(),
                ),
              ),
            ),
            Visibility(
              visible: showCaptcha,
              child: AnimatedBuilder(
                animation: animationInput,
                builder: (context, child) {
                  return showCaptcha
                      ? Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(0),
                          height: animationInput.value,
                          width: 300,
                          child: TextFormField(
                            controller: captchaController,
                            maxLines: 1,
                            cursorHeight: 20,
                            cursorWidth: 1,
                            textAlign: TextAlign.center,
                            style: textStyle(),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear, size: iconSize, color: iconColor),
                                onPressed: () async => captchaController.clear(),
                              ),
                              icon: Icon(Icons.verified, size: iconSize, color: iconColor),
                              labelText: Lang().captcha,
                              labelStyle: textStyle(),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ),
            AnimatedBuilder(
              animation: animationEmail,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(0),
                  width: 300,
                  child: TextFormField(
                    controller: emailController,
                    maxLines: 1,
                    cursorHeight: 20,
                    cursorWidth: 1,
                    textAlign: TextAlign.center,
                    style: textStyle(),
                    onChanged: (text) async {
                      if (text.isNotEmpty && text != userNotifier.userModel.email) {
                        sendStatus = true;
                        animationControllerEmail.forward();
                        showCaptcha = true;
                        animationControllerInput.forward();
                      } else {
                        animationControllerEmail.reverse().whenCompleteOrCancel(() => sendStatus = false);
                        animationControllerInput.reverse().then((value) => showCaptcha = false);
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      suffixIcon: sendStatus
                          ? IconButton(
                              icon: Icon(Icons.send, size: animationEmail.value, color: iconColor),
                              onPressed: () async {
                                userNotifier.sendEmail(url: appUrl, email: emailController.text, sendType: 3);
                              },
                            )
                          : null,
                      icon: Icon(Icons.mail, size: iconSize, color: iconColor),
                      labelText: Lang().email,
                      labelStyle: textStyle(),
                    ),
                  ),
                );
              },
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
                  userNotifier.modifyPersonalData(
                    url: appUrl,
                    name: nameController.text,
                    password: passwordController.text,
                    email: emailController.text,
                    captcha: captchaController.text,
                  );
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
