import 'package:get/get.dart';
import 'package:note_book/model/data_source/sqflite_db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
String? lang;

class NotebookServices extends GetxService {
  bool? isFirstTime;
  Future<NotebookServices> getInitalApp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isFirstTime = sharedPreferences!.getBool("isFirstTime");
    lang = sharedPreferences!.getString("lang");
    SqlDB db = SqlDB();
    await db.initDB();
    if (isFirstTime == null) {
      Get.offNamed('/change');
    }
    return this;
  }
}
