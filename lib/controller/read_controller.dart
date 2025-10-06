import 'dart:io';
import 'dart:math';
import 'package:note_book/controller/utils_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:audioplayers/audioplayers.dart';
import 'package:external_path/external_path.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:note_book/model/notes.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ReadController extends GetxController {
  Note? note;
  bool isPlaying = false;
  double value = 0.0;
  Duration? duration = const Duration(seconds: 0);
  AudioPlayer audioPlayer = AudioPlayer();

  Future initPlayer() async {
    if (note!.noteRecord == "empty") {
    } else {
      await audioPlayer.setSource(DeviceFileSource(note!.noteRecord!));
      duration = await audioPlayer.getDuration();
      duration = duration;
      update();
    }
  }

  Future onPlayPressed() async {
    await audioPlayer.resume();
    isPlaying = true;
    update();
    debugPrint("Current:$value\nDuration:$duration");
    audioPlayer.onPositionChanged.listen((position) {
      value = position.inSeconds.toDouble();
      update();
    });
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      value = 0.0;
      audioPlayer.stop();
      update();
    });
    update();
  }

  Future onPausedPressed() async {
    await audioPlayer.pause();
    isPlaying = false;
    update();
  }

  Future onStopPressed() async {
    audioPlayer.stop();
    isPlaying = false;
    update();
  }

  Future onChangedUser(double v) async {
    if (isPlaying == true) {
      await audioPlayer.pause();
      isPlaying = false;
      value = v;
      update();
    } else {
      isPlaying = false;
      value = v;
      update();
    }
  }

  Future onChangedEndUser(double newValue) async {
    value = newValue;
    isPlaying = true;
    update();
    await audioPlayer.pause();
    await audioPlayer.seek(Duration(seconds: newValue.toInt()));
    await audioPlayer.resume();
    isPlaying = true;
    update();
  }

  String get getCurrentDuration =>
      "${(value / 60).floor() < 10 ? "0${(value / 60).floor()}" : (value / 60).floor()}:${(value % 60).floor() < 10 ? "0${(value % 60).floor()}" : (value % 60).floor()}";
  String get totalDuration =>
      "${duration!.inMinutes < 10 ? "0${duration!.inMinutes}" : duration!.inMinutes}:${duration!.inSeconds % 60 < 10 ? "0${duration!.inSeconds % 60}" : duration!.inSeconds % 60}";
  Future getPath() async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    return path;
  }

  Future saveAudioClient() async {
    if (note!.noteRecord! == "empty") {
    } else {
      bool isExists = await saveAudio(note!.noteRecord!);
      if (isExists == true) {
        if (Platform.isWindows) {
          UtilsController().showSnackBarGet("message".tr, "recordsave".tr);
        } else {
          UtilsController().showToastFromNative("recordsave".tr, 1);
        }
      } else {
        if (Platform.isWindows) {
          UtilsController().showSnackBarGet("message".tr, "nofile".tr);
        } else {
          UtilsController().showToastFromNative("nofile".tr, 1);
        }
      }
    }
  }

  Future savePDFClient() async {
    if ((note!.noteTitle.isArabicGetx() && note!.noteContent.isArabicGetx()) ||
        (note!.noteTitle.isArabicGetx() || note!.noteContent.isArabicGetx())) {
      if (Platform.isWindows) {
        UtilsController().showSnackBarGet("message".tr, "pdfsavear".tr);
      } else {
        UtilsController().showToastFromNative("pdfsavear".tr, 1);
      }
    } else {
      await savePDF(note!.noteTitle, note!.noteContent);
      if (Platform.isWindows) {
        UtilsController().showSnackBarGet("message".tr, "pdfsave".tr);
      } else {
        UtilsController().showToastFromNative("pdfsave".tr, 1);
      }
    }
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
      if ((noteTitle.isArabicGetx() || noteContent.isArabicGetx()) ||
          (noteTitle.isArabicGetx() && noteContent.isArabicGetx())) {
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
        UtilsController().showToastFromNative("PDF Generation Error: $e", 1);
      }
    }
  }

  @override
  void onInit() {
    note = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    initPlayer();
    super.onReady();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
