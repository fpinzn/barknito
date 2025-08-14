import 'dart:convert';

import 'package:barknito/first_bark/blinking_dot.dart';
import 'package:barknito/first_bark/blinking_dot_with_text.dart';
import 'package:barknito/first_bark/first_bark_page.dart';
import 'package:barknito/typography.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_classification/sound_classification_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        children: <Widget>[
          FirstBarkPage(pageController: controller),
          FirstBarkDone(),
          Container(
              height: 700,
              color: Colors.red,
              child: Center(child: Text('Page 1'))),
          Container(
              height: 700,
              color: Colors.blue,
              child: Center(child: Text('Page 2'))),
          Container(
              height: 700,
              color: Colors.green,
              child: Center(child: Text('Page 3'))),
        ],
      )
          // FirstBarkPage(),
          ),
    );
  }
}

class FirstBarkDone extends StatelessWidget {
  const FirstBarkDone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BlinkingDotWithText(
                text: 'If your dog didn\'t bark, swipe down to try again',
                dotColor: Colors.black,
                dotSize: 10,
                spacing: 12,
              ),
              const SizedBox(height: 50),
              Center(child: Image.asset('assets/images/bark.png')),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: NarrationBlack(
                    'The bestial and loud spirit filled the desert with its power'),
              ),
              const SizedBox(height: 50),
              const BlinkingDot(color: Colors.black),
            ],
          ),
        ));
  }
}
