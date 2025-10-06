import 'dart:io';
import 'dart:math';
import 'package:external_path/external_path.dart';
import 'package:get/get.dart';
import 'package:jni/jni.dart';
import 'package:path_provider/path_provider.dart';
import 'bindings/hardware_utils_bindings.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

final record = AudioRecorder();

class UtilsController {
  void showToastFromNative(String message, int duration) async {
    if (Platform.isAndroid) {
      JString nativeMessage = message.toJString();
      final activity = JObject.fromReference(Jni.getCurrentActivity());
      KotlinHardwareUtils().customShowToast(activity, nativeMessage, duration);
    }
  }

  void showSnackBarGet(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }

  void chooseImage(
      {String? title,
      String? galleryContent,
      String? cameraContent,
      Color? color,
      void Function()? onCamera,
      void Function()? onGallery}) {
    Get.bottomSheet(Container(
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
          const SizedBox(
            height: 5,
          ),
          ListTile(
            onTap: onGallery,
            leading: const Icon(Icons.photo),
            title: Text(
              galleryContent!,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
          ListTile(
            onTap: onCamera,
            leading: const Icon(Icons.camera),
            title: Text(
              cameraContent!,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      ),
    ));
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
        showToastFromNative("Error:$e", 1);
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
      ExternalPath.DIRECTORY_DOWNLOAD);
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
