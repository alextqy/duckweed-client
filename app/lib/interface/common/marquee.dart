// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:app/interface/common/pub_lib.dart';
import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  late List<String> data;
  late int interval; // 停留时间
  late int switchingSpeed; // 切换速度

  Marquee({required this.data, this.interval = 3, this.switchingSpeed = 1, super.key});

  @override
  MarqueeState createState() => MarqueeState();
}

class MarqueeState extends State<Marquee> {
  late PageController controller;
  late Timer timer;

  buildPageViewItemWidget(int index) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
      child: Tooltip(
        decoration: tooltipStyle(),
        textStyle: textStyle(),
        message: widget.data[index],
        child: Text(widget.data[index], maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle()),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    controller = PageController();

    timer = Timer.periodic(Duration(seconds: widget.interval), (timer) {
      if (controller.page!.round() >= widget.data.length) {
        controller.jumpToPage(0);
      }
      controller.nextPage(duration: Duration(seconds: widget.switchingSpeed), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: controller,
      itemBuilder: (buildContext, index) {
        if (widget.data.isNotEmpty && index < widget.data.length) {
          return buildPageViewItemWidget(index);
        } else {
          return buildPageViewItemWidget(0);
        }
      },
      itemCount: widget.data.isNotEmpty ? widget.data.length + 1 : 0,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }
}
