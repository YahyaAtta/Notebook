import 'dart:io';
import 'package:get/get.dart';
import 'package:note_book/localizations/locale_controller.dart';
import 'package:note_book/model/data_source/sqflite_db_provider.dart';
import '../services/service.dart';

class SettingsController extends GetxController {
  late bool isCleared;
  bool isDark = Get.isDarkMode;
  SqlDB sqlDB = SqlDB();
  String selectedLang = lang == null
      ? sharedPreferences!.getString("lang")!
      : sharedPreferences!.getString("lang")!;
  void changeLanguage(String c) {
    LocaleController localeController = Get.find<LocaleController>();
    selectedLang = c;
    localeController.changeLang(selectedLang);
    update();
  }

  Future<void> resetApp() async {
    isCleared = await sharedPreferences!.clear();
    SqlDB sqlDB = SqlDB();
    List? getNotes = await sqlDB.readData("SELECT * FROM `notes`");
    for (int i = 0; i < getNotes.length; i++) {
      if (getNotes[i]['noteRecord'] != "empty") {
        await File(getNotes[i]['noteRecord']).delete();
      }
      if (getNotes[i]['noteImageUrl'] != "empty") {
        await File(getNotes[i]['noteImageUrl']).delete();
      }
    }
    int r = await sqlDB.deleteData("DELETE FROM `notes`");
    if (isCleared == true && (r > 0 || r == 0)) {
      await sqlDB.myDeleteDatabase();
      exit(0);
    }
  }
}
