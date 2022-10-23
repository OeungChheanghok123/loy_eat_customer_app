import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/route_controller.dart';
import 'package:loy_eat_customer/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Loy Eat customer",
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: getRoutPage,
      home: Home(),
    );
  }
}