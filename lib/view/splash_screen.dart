import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/sqflite_db_provider.dart';
import 'package:note_book/main.dart';
import 'package:note_book/view/Home/home_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:note_book/view/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  void initApp() async {
    SqlDB db = SqlDB();
    await db.initDB();
    if (isFirstTime == null) {
      if (mounted) {
        await audioPlayer.play(AssetSource("start-computeraif-14572.mp3"));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Intro()));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: Image.asset(notebookLogo,
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width),
    ));
  }
}
