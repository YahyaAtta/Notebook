import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/settings_controller.dart';
import 'package:note_book/localizations/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final LocaleController localeController = LocaleController();
  final SettingsController settingsController = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings".tr,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: GetBuilder<SettingsController>(
              builder: (c) => Column(
                    spacing: 30,
                    children: [
                      Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(20),
                          leading: Icon(Icons.restore),
                          title: Text("resetapp".tr),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              onPressed: () {
                                Get.defaultDialog(
                                    title: "message".tr,
                                    textConfirm: 'ok'.tr,
                                    middleText: 'middletext'.tr,
                                    onConfirm: () {
                                      settingsController.resetApp();
                                    },
                                    textCancel: 'cancel'.tr);
                              },
                              child: Text("reset".tr)),
                        ),
                      ),
                      ExpansionTile(
                        title: Text("choose".tr),
                        children: [
                          Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  RadioGroup(
                                      groupValue:
                                          settingsController.selectedLang,
                                      onChanged: (c) {
                                        settingsController.changeLanguage(c!);
                                        localeController.changeLang("en");
                                      },
                                      child: Row(
                                        spacing: 10,
                                        children: [
                                          Radio(value: 'en'),
                                          Text("enu".tr),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  RadioGroup(
                                      groupValue:
                                          settingsController.selectedLang,
                                      onChanged: (c) {
                                        settingsController.changeLanguage(c!);
                                        localeController.changeLang("ar");
                                      },
                                      child: Row(
                                        spacing: 10,
                                        children: [
                                          Radio(value: 'ar'),
                                          Text("ara".tr),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
