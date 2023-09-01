import 'package:app/common/lang.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  double iconSize = 20;
  bool obscureText = true;

  TextStyle textStyle({Color color = Colors.white70, double fontSize = 15}) {
    return TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: fontSize, textBaseline: TextBaseline.alphabetic);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController captchaController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
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
                        icon: Icon(Icons.send, size: iconSize, color: Colors.white70),
                        onPressed: () {
                          print("email");
                        },
                      ),
                      icon: Icon(Icons.email, size: iconSize, color: Colors.white70),
                      labelText: Lang().email,
                      labelStyle: textStyle(),
                    ),
                  ),
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
                    icon: Icon(Icons.remove_red_eye, size: iconSize, color: Colors.white70),
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
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              width: 200,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: InkWell(
                child: Center(
                  child: Text("OK", style: textStyle()),
                ),
                onTap: () {},
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
