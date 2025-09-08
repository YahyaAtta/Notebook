import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:note_book/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controller/Logic/time_command.dart';
import 'package:shared_preferences/shared_preferences.dart';

String notebookLogo = "assets/icon/note_book.jpeg";
SharedPreferences? sharedPreferences;
bool? isFirstTime;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  isFirstTime = sharedPreferences!.getBool("FirstTime");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => NotesModel()),
    ChangeNotifierProvider(create: (context) => TimeModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      title: 'Notebook',
      theme: ThemeData(
        fontFamily: 'robotocondensed-regular',
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffFFCF15), brightness: Brightness.light),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffE7E0EC),
        )),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'robotocondensed-regular',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffFFCF15), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
