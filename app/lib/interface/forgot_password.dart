import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/common/file.dart";
import "package:app/interface/common/show_alert_dialog.dart";
import "package:app/notifier/base_notifier.dart";
import "package:app/notifier/user_notifier.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> with TickerProviderStateMixin {
  String url = "";

  double iconSize = 20;
  int showSpeed = 450;
  bool obscureText = true;
  bool sendMail = true;

  late AnimationController animationControlleBtn;
  late AnimationController animationControlleEmail;
  late Animation<double> animationBtn;
  late Animation<double> animationEmail;

  TextStyle textStyle({Color color = Colors.white70, double fontSize = 15}) {
    return TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: fontSize, textBaseline: TextBaseline.alphabetic);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController captchaController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  UserNotifier userNotifier = UserNotifier();

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

    userNotifier.addListener(basicListener);

    animationControlleBtn = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationControlleEmail = AnimationController(duration: Duration(milliseconds: showSpeed), vsync: this);
    animationBtn = Tween(begin: 150.0, end: 0.0).animate(animationControlleBtn);
    animationEmail = Tween(begin: 20.0, end: 0.0).animate(animationControlleEmail);
  }

  // 发送邮件动效
  void playAnimationEmail() async {
    try {
      if (emailController.text.isNotEmpty) {
        sendMail = false;
        await animationControlleEmail.forward().orCancel;
        await animationControlleEmail.reverse().orCancel;
        Future.delayed(const Duration(milliseconds: 2000)).then((value) async {
          userNotifier.sendEmail(url: url, email: emailController.text);
          sendMail = true;
        });
      }
    } on TickerCanceled {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    url = FileHelper().setUrl();
    String btnContent = "OK";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Lang().forgotPassword,
          style: textStyle(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            Row(
              children: [
                const Expanded(child: SizedBox()),
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
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, size: animationEmail.value, color: Colors.white70),
                            onPressed: () {
                              if (sendMail == true) {
                                playAnimationEmail();
                              }
                            },
                          ),
                          icon: Icon(Icons.email, size: iconSize, color: Colors.white70),
                          labelText: Lang().email,
                          labelStyle: textStyle(),
                        ),
                      ),
                    );
                  },
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
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
                    icon: Icon(Icons.clear, size: iconSize, color: Colors.white70),
                    onPressed: () => captchaController.clear(),
                  ),
                  icon: Icon(Icons.verified, size: iconSize, color: Colors.white70),
                  labelText: Lang().captcha,
                  labelStyle: textStyle(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(0),
              width: 300,
              child: TextFormField(
                controller: newPasswordController,
                maxLines: 1,
                obscureText: obscureText,
                cursorHeight: 20,
                cursorWidth: 1,
                textAlign: TextAlign.center,
                style: textStyle(),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, size: iconSize, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  icon: Icon(Icons.password, size: iconSize, color: Colors.white70),
                  labelText: Lang().newPassword,
                  labelStyle: textStyle(),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animationBtn,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(0),
                  width: animationBtn.value,
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
                      if (captchaController.text.isNotEmpty && newPasswordController.text.isNotEmpty) {
                        userNotifier.resetPassword(url: url, captcha: captchaController.text, newPassword: newPasswordController.text);
                        if (userNotifier.result.state == true) {
                          emailController.clear();
                          captchaController.clear();
                          newPasswordController.clear();

                          btnContent = "";
                          animationControlleBtn.forward();
                        }
                      }
                    },
                  ),
                );
              },
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
