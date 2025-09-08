import 'package:flutter/material.dart';
import 'package:note_book/controller/Animation/app_animate.dart';
import 'package:note_book/view/Home/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:math';

GlobalKey<FormState> formState = GlobalKey<FormState>();
final record = AudioRecorder();
int n = 0;

class AppRoute {
  Future startRecord() async {
    n = Random().nextInt(100000000);
    if (await record.hasPermission()) {
      String path =
          '${(await getApplicationDocumentsDirectory()).path}/audio_$n.m4a';
      await record.start(const RecordConfig(), path: path);
      return path;
    }
    Future stopRecord() async {
      await record.stop();
    }

    Future cancelRecord() async {
      await record.stop();
    }

    Future disposeRecord() async {
      await record.dispose();
    }
  }

  static void customShowDialog(
      {required BuildContext context,
      String? content,
      String? title,
      IconData? icondata}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(content!),
            title: Text(title!),
            icon: Icon(icondata!, size: 40),
            actions: [
              TextButton(
                onPressed: () {
                  AppRoute.goBack(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  static Future<void> showSnack(
      {required BuildContext context, String? content}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content!),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  static void chooseImage(
      {required BuildContext context,
      String? title,
      String? galleryContent,
      String? cameraContent,
      void Function()? onCamera,
      void Function()? onGallery}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 23),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  onTap: onGallery,
                  leading: const Icon(Icons.photo),
                  title: Text(
                    galleryContent!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
                ListTile(
                  onTap: onCamera,
                  leading: const Icon(Icons.camera),
                  title: Text(
                    cameraContent!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static bool isValidEmail(String email) {
    String regEmail =
        "r'^(([^<>()[]\\.,;:s@\"]+(.[^<>()[]\\.,;:s@\"]+)*)|(\".+\"))@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}])|(([a-zA-Z-0-9]+.)+[a-zA-Z]{2,}))\$";
    return RegExp(regEmail).hasMatch(email);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void goHome(BuildContext context) {
    Navigator.of(context).pushReplacement(Slide(page: const HomeScreen()));
  }

  static void goAddNote(BuildContext context, pagedata) {
    Navigator.of(context).push(CupertinoAnimation(page: pagedata));
  }

  static void goEditNote(BuildContext context, pagedata) {
    Navigator.of(context).push(CupertinoAnimation(page: pagedata));
  }

  static void goReadNote(BuildContext context, pagedata) {
    Navigator.of(context).push(
      CupertinoAnimation(page: pagedata),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
