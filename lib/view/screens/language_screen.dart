import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/localizations/locale_controller.dart';
import 'package:note_book/model/data_static/assets_model.dart';

import '../../services/service.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});
  final LocaleController locale = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: lang == null ? Alignment.topLeft : Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    if (Get.isDarkMode) {
                      Get.changeTheme(ThemeData(
                        fontFamily: 'robotocondensed-regular',
                        colorScheme: ColorScheme.fromSeed(
                            seedColor: const Color(0xffd5b001),
                            brightness: Brightness.light),
                        brightness: Brightness.light,
                        elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 86, 59, 2),
                        )),
                        useMaterial3: true,
                      ));
                    } else {
                      Get.changeTheme(ThemeData(
                        fontFamily: 'robotocondensed-regular',
                        brightness: Brightness.dark,
                        colorScheme: ColorScheme.fromSeed(
                            seedColor: const Color(0xffd5b001),
                            brightness: Brightness.dark),
                        useMaterial3: true,
                      ));
                    }
                  },
                  icon: Icon(Icons.light_mode_rounded)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Image.asset(
                height: 220,
                width: 220,
                AssetsIconModel.notebookLogo,
              ),
            ),
            Text("choose".tr),
            ElevatedButton(
                onPressed: () {
                  locale.changeLang("ar");
                  Get.offNamed("/Intro");
                },
                child: Text(
                  "ara".tr,
                  style: TextStyle(
                      color: Get.isDarkMode == false
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary),
                )),
            ElevatedButton(
                onPressed: () {
                  locale.changeLang("en");
                  Get.offNamed("/Intro");
                },
                child: Text(
                  "enu".tr,
                  style: TextStyle(
                      color: Get.isDarkMode == false
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary),
                ))
          ],
        ),
      ),
    );
  }
}
