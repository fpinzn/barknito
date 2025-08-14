import 'dart:convert';

import 'package:barknito/first_bark/first_bark_page.dart';
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
