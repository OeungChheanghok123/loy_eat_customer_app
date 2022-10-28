import 'package:flutter/material.dart';

class ScreenWidgets {

  static Widget get loading {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget get error {
    return const Text('Error while loading data from server.');
  }

  static Widget get none {
    return const Center(
      child: Text('No Store here.',style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      )),
    );
  }
}