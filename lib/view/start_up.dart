import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/view/home.dart';

class StartUp extends StatelessWidget {
  const StartUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () => Get.to(() => Home()));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 180, 213),
      body: Container(
        color: const Color.fromRGBO(255, 0, 180, 213),
        child: const Center(
          child: Image(image: AssetImage('assets/image/logo_merchant.png')),
        ),
      ),
    );
  }
}