import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final String _customerNumber = 'customerNumber';

  void writeCache (String data) async {
    SharedPreferences pref  = await SharedPreferences.getInstance();
    pref.setString(_customerNumber, data);
  }

  Future<String> readCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_customerNumber) ?? '';
  }

  void removeCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(_customerNumber);
    debugPrint('_merchantId: $_customerNumber');
  }
}