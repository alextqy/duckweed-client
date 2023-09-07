// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import "package:app/common/lang.dart";
import "package:app/interface/common/pub_lib.dart";

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({super.key});

  @override
  State<PersonalSettings> createState() => PersonalSettingsState();
}

class PersonalSettingsState extends State<PersonalSettings> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        backgroundColor: bgColor(context),
        title: Text(Lang().personalSettings, style: textStyle()),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
