import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final String _merchantId = 'merchantId';

  void writeCache (String data) async {
    SharedPreferences pref  = await SharedPreferences.getInstance();
    pref.setString(_merchantId, data);
  }

  Future<String> readCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_merchantId) ?? '';
  }

  void removeCache() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(_merchantId);
    debugPrint('_merchantId: $_merchantId');
  }
}