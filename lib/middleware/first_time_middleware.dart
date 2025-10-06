import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/services/service.dart';

class FirstTimeMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharedPreferences!.getBool("isFirstTime") != null) {
      return RouteSettings(name: '/home');
    }
    return null;
  }
}
