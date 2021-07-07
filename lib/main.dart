import 'dart:convert';

import 'package:best_architecture_challenge/core/core_injection.dart';
import 'package:best_architecture_challenge/screens/home/bindings/home_bindings.dart';
import 'package:best_architecture_challenge/screens/home/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  CoreInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeView(), binding: HomeBindings()),
      ],
    );
  }
}
