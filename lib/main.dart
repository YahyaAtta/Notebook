import 'package:flutter/material.dart';
import 'package:note_book/controller/bindings/note_book_bindings.dart';
import 'package:note_book/localizations/locale_controller.dart';
import 'package:note_book/localizations/notebook_locale.dart';
import 'package:note_book/middleware/first_time_middleware.dart';
import 'package:note_book/services/service.dart';
import 'package:note_book/view/screens/language_screen.dart';
import 'package:note_book/view/screens/CRUD/add_note.dart';
import 'package:note_book/view/screens/CRUD/read_note.dart';
import 'package:note_book/view/screens/CRUD/custom.dart';
import 'package:note_book/view/screens/CRUD/update_custom.dart';
import 'package:note_book/view/screens/CRUD/update_note.dart';
import 'package:note_book/view/screens/about_us.dart';
import 'package:note_book/view/screens/current_time.dart';
import 'package:note_book/view/screens/device_info.dart';
import 'package:note_book/view/screens/home_screen.dart';
import 'package:note_book/view/screens/onboarding.dart';
import 'package:note_book/view/screens/settings.dart';
import 'package:note_book/view/screens/splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const MyApp());
}

Future initApp() async {
  Get.putAsync(() => NotebookServices().getInitalApp());
}

class MyApp extends GetView<NotebookServices> {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.put(LocaleController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: NotebookBindings(),
      defaultTransition: Transition.rightToLeft,
      translations: NotebookLocale(),
      locale: localeController.defaultLocale,
      initialRoute: '/splash',
      getPages: [
        GetPage(
            name: '/splash',
            page: () => SplashScreen(),
            middlewares: [FirstTimeMiddleWare()]),
        GetPage(name: '/change', page: () => LanguageScreen()),
        GetPage(
          name: '/Intro',
          page: () => Intro(),
        ),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/time', page: () => CurrentTime()),
        GetPage(name: '/device', page: () => NativeDeviceInfo()),
        GetPage(name: '/addnote', page: () => AddNote()),
        GetPage(name: '/readnote', page: () => ReadNote()),
        GetPage(name: '/updatenote', page: () => UpdateNote()),
        GetPage(name: '/custom', page: () => Custom()),
        GetPage(name: '/customupdate', page: () => UpdateCustom()),
        GetPage(name: '/about', page: () => About()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
      title: 'Notebook',
      theme: ThemeData(
        fontFamily: 'robotocondensed-regular',
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffd5b001), brightness: Brightness.light),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 86, 59, 2),
        )),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'robotocondensed-regular',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffd5b001), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
