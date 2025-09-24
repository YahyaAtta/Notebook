import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:note_book/hardware_utils_bindings.dart';
import 'package:path/path.dart';
// import 'package:jni/jni.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_book/controller/Animation/app_animate.dart';
import 'package:note_book/view/Home/device_info.dart';
import 'package:note_book/view/Home/home_screen.dart';
import 'package:record/record.dart';
import 'dart:math';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:external_path/external_path.dart';

// import 'package:jni/jni.dart' ;
GlobalKey<FormState> formState = GlobalKey<FormState>();
final record = AudioRecorder();
int n = 0;

class AppLogic {
  void showToastFromNative(String message, int duration) async {
    if (Platform.isAndroid) {
      JString nativeMessage = message.toJString();
      final activity = JObject.fromReference(Jni.getCurrentActivity());
      KotlinHardwareUtils().customShowToast(activity, nativeMessage, duration);
    }
  }

  Map<String, String> getDeviceFromNative() {
    if (Platform.isAndroid) {
      final dartMap = <String, String>{};
      final jMap = KotlinHardwareUtils().getHardwareKotlinUtils();
      final JSet<JString> keys = jMap.keys;
      for (JString jkey in keys) {
        final String key = jkey.toDartString();
        final JString? jVal = jMap[jkey];
        dynamic value;
        if (jVal == null) {
          value = null;
        } else {
          value = jVal.toDartString();
        }

        dartMap[key] = value;
      }
      return dartMap;
    }
    return {};
  }

  Future<bool> saveAudio(String noteRecord) async {
    bool isExists = false;
    if (noteRecord == "empty") {
      isExists = false;
      return isExists;
    } else {
      isExists = true;
      if (Platform.isAndroid) {
        await FileSaver.instance.saveAs(
            name: basenameWithoutExtension(noteRecord),
            fileExtension: 'aac',
            mimeType: MimeType.aac,
            filePath: "${await getPath()}/${basename(noteRecord)}",
            bytes: File(noteRecord).readAsBytesSync());
      } else {
        await FileSaver.instance.saveAs(
            name: basenameWithoutExtension(noteRecord),
            fileExtension: 'aac',
            mimeType: MimeType.aac,
            filePath:
                "${(await getApplicationDocumentsDirectory()).path}/${basename(noteRecord)}",
            bytes: File(noteRecord).readAsBytesSync());
      }
      return isExists;
    }
  }

  Future<void> savePDF(String noteTitle, String noteContent) async {
    int r = Random().nextInt(1000000);
    final pdf = pw.Document();
    try {
      if ((noteTitle.isArabic() || noteContent.isArabic()) ||
          (noteTitle.isArabic() && noteContent.isArabic())) {
        // Load Arabic Font from Asset
        final fontData =
            await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
        if (fontData.lengthInBytes == 0) {
          throw Exception('Arabic font not found or empty!');
        }
        final arabicFont = pw.Font.ttf(fontData);

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    'عنوان الملاحظة: $noteTitle\nمحتوى الملاحظة: $noteContent',
                    style: pw.TextStyle(font: arabicFont),
                  ),
                ),
              );
            }));
      } else {
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Note Title: $noteTitle"),
                      pw.SizedBox(height: 15),
                      pw.Text("NoteContent: $noteContent")
                    ]),
              );
            }));
      }
      // Save The pdf
      final pdfBytes = await pdf.save();
      // Check if pdfBytes is Empty
      if (pdfBytes.isEmpty) {
        throw Exception('PDF save failed or returned empty data!');
      }
      String savePDF = Platform.isAndroid
          ? await getPath()
          : (await getApplicationDocumentsDirectory()).path;
      File pdfFile = File("$savePDF/doc$r.pdf");
      await pdfFile.writeAsBytes(pdfBytes);
      if (Platform.isAndroid) {
        FileSaver.instance.saveAs(
            name: basenameWithoutExtension(pdfFile.path),
            fileExtension: 'pdf',
            filePath: "${await getPath()}/${basename(pdfFile.path)}",
            mimeType: MimeType.pdf);
      } else {
        FileSaver.instance.saveAs(
            name: basenameWithoutExtension(pdfFile.path),
            fileExtension: 'pdf',
            filePath:
                "${(await getApplicationDocumentsDirectory()).path}/${basename(pdfFile.path)}",
            mimeType: MimeType.pdf);
      }
    } catch (e) {
      if (Platform.isAndroid) {
        AppLogic().showToastFromNative("PDF Generation Error: $e", 1);
      }
    }
  }

  Future<String?> startRecord() async {
    try {
      n = Random().nextInt(100000000);
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
        AppLogic().showToastFromNative("Error: $e", 1);
      }
    }

    return null;
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
                  AppLogic.goBack(context);
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

  static void goDeviceInfoPage(BuildContext context) {
    Navigator.of(context).push(CupertinoAnimation(page: NativeDeviceInfo()));
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

extension ArabicExtension on String {
  bool isArabic() {
    String arabicPattern = r'[\u0600-\u06FF]';
    RegExp regExp = RegExp(arabicPattern);
    return regExp.hasMatch(this);
  }
}
