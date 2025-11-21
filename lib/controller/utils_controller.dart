import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:external_path/external_path.dart';
import 'package:get/get.dart';
import 'package:jni/jni.dart';
import 'package:path_provider/path_provider.dart';
import 'bindings/hardware_utils_bindings.dart' as android;
import 'package:flutter/material.dart';
import 'package:record/record.dart';

final record = AudioRecorder();

android.Context getAndroidContext() {
  JObject c = Jni.androidApplicationContext;
  android.Context context = c.as<android.Context>(android.Context.type);
  return context;
}

android.Activity getAndroidActivity() {
  final a = Jni.androidActivity(PlatformDispatcher.instance.engineId!);
  final android.Activity activity = a!.as<android.Activity>(
    android.Activity.type,
  );
  return activity;
}

class AndroidDialog {
     
  static void showDialog({required String title, required String message}) {
    final activity = getAndroidActivity();
    final context = getAndroidContext();
    activity.runOnUiThread(
      android.Runnable.implement(
        android.$Runnable(
          run: () {
            android.AlertDialog$Builder builder =
                android.AlertDialog$Builder.new$1(context ,1);
            builder.setTitle$1(JString.fromString(title));
            builder.setMessage$1(JString.fromString(message));
            builder.setPositiveButton$1(
              JString.fromString("OK"),
              android.DialogInterface$OnClickListener.implement(
                android.$DialogInterface$OnClickListener(
                  onClick: (dialog, which) {
                    dialog!.dismiss();
                  },
                ),
              ),
            );
            builder.show();
          },
        ),
      ),
    );
  }
}

class Toast {
  static void makeText({required String text, required int duration}) {
    if (Platform.isAndroid) {
      final activity = getAndroidActivity();
      final context = getAndroidContext();
      activity.runOnUiThread(
        android.Runnable.implement(
          android.$Runnable(
            run: () {
              android.Toast.makeText$1(
                context,
                JString.fromString(text),
                duration,
              );
            },
          ),
        ),
      );
    }
  }
}

class UtilsController {
  Future<void> openUrlInBrowserAndroid(String url) async {
    if (Platform.isAndroid) {
      final context = getAndroidContext();
      final android.Intent intent = android.Intent.new$3(
        android.Intent.ACTION_VIEW,
      ); // Create Intent
      final android.Uri? urlBrowser = android.Uri.parse(
        url.toJString(),
      ); // Set Uri
      intent.setData(urlBrowser); // setData to Intent
      intent.setFlags(
        android.Intent.FLAG_ACTIVITY_NEW_TASK,
      ); // setFlag to Intent
      try {
        context.startActivity(
          intent,
        ); // Launching Uri into Browser Using intent
      } on JniException catch (e) {
        // showToastFromNative(e.message.toString(), 1);
        Toast.makeText(text: e.message, duration: 1);
      } finally {
        context.release(); // release context  from Memory
        urlBrowser!.release(); // release urlBrowser from Memory
        intent.release(); // release intent from Memory
      }
    }
  }

  // void showToastAndroid(
  //   android.Context context,
  //   JString nativeMessage,
  //   int duration,
  // ) {

  // }

  // void showToastFromNative(String message, int duration) async {
  //   if (Platform.isAndroid) {
  //     final context = getAndroidContext();
  //     JString nativeMessage = message.toJString();
  //     showToastAndroid(context, nativeMessage, duration);
  //   }
  // }

  void showSnackBarGet(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }

  void chooseImage({
    String? title,
    String? galleryContent,
    String? cameraContent,
    Color? color,
    void Function()? onCamera,
    void Function()? onGallery,
  }) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(20),
        height: 200,
        width: double.infinity,
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 23),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: onGallery,
              leading: const Icon(Icons.photo),
              title: Text(
                galleryContent!,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              onTap: onCamera,
              leading: const Icon(Icons.camera),
              title: Text(
                cameraContent!,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> startRecord() async {
    try {
      int n = Random().nextInt(100000000);
      if (await record.hasPermission()) {
        String path =
            '${(await getApplicationDocumentsDirectory()).path}/audio_$n.aac';
        await record.start(const RecordConfig(), path: path);
        return path;
      } else {
        return null;
      }
    } catch (e) {
      if (Platform.isAndroid) {
        Toast.makeText(text: "Error: $e", duration: 1);
      } else {
        showSnackBarGet("Message", "Error:$e");
      }
    }
    return null;
  }
}

Future<bool> isRecordingWhile() async {
  return await record.isRecording();
}

Future getPath() async {
  String path = await ExternalPath.getExternalStoragePublicDirectory(
    ExternalPath.DIRECTORY_DOWNLOAD,
  );
  return path;
}

Future stopRecord() async {
  await record.stop();
}

Future cancelRecord() async {
  await record.cancel();
}

Future pauseRecord() async {
  await record.pause();
}

Future disposeRecord() async {
  await record.dispose();
}

extension ArabicExtension on String {
  bool isArabicGetx() {
    String arabicPattern = r'[\u0600-\u06FF]';
    RegExp regExp = RegExp(arabicPattern);
    return regExp.hasMatch(this);
  }
}

extension EnglishExtension on String {
  bool isEnglishGetx() {
    String englishPattern = r'^[a-zA-Z]+';
    RegExp regExp = RegExp(englishPattern);
    return regExp.hasMatch(this);
  }
}
