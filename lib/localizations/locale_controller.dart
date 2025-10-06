import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/services/service.dart';

class LocaleController extends GetxController {
  Locale? defaultLocale = lang == null ? Get.deviceLocale : Locale(lang!);

  void changeLang(String code) {
    Locale locale = Locale(code);
    sharedPreferences!.setString("lang", code);
    Get.updateLocale(locale);
  }
}
