import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/controller/utils_controller.dart';
import 'package:note_book/model/data_source/sqflite_db_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddNoteController extends GetxController {
  bool isPicked = false;
  File? image;
  File? newImage;
  String? imagePathAdd;
  SqlDB sqldb = SqlDB();
  DateTime? selectedDate;
  String? noteDate;
  String? noteTime;
  bool isPaused = false;
  bool isRecording = false;
  String? getPathAudio;
  UtilsController utilsController = UtilsController();
  final NoteController controller = Get.find<NoteController>();

  Future addNoteToDatabase(
      {String? noteTitle,
      String? noteContent,
      int? noteColor,
      int? contentIndex,
      double? contentSize,
      String? noteRecord,
      String? contentType,
      String? fontStyle,
      String? fontWeight,
      String? noteImageUrl}) async {
    isPicked = true;
    controller.addNote(
        noteTitle: noteTitle,
        noteContent: noteContent,
        noteColor: noteColor,
        contentIndex: contentIndex,
        contentSize: contentSize,
        noteRecord: noteRecord,
        noteDate: noteDate,
        contentType: contentType,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        noteImageurl: noteImageUrl,
        noteTime: noteTime);
  }

  void getCurrentDateAndTime() {
    String? month;
    selectedDate = DateTime.now();
    noteTime =
        "${selectedDate!.hour < 10 ? "0${selectedDate!.hour}" : selectedDate!.hour}:${selectedDate!.minute < 10 ? "0${selectedDate!.minute}" : selectedDate!.minute}:${selectedDate!.second < 10 ? "0${selectedDate!.second}" : selectedDate!.second}";
    switch (selectedDate!.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    noteDate = "${selectedDate!.day} $month ${selectedDate!.year}";
  }

  void refreshGet() async {
    update();
  }

  Future onPressedStartRecording() async {
    if (isRecording == false) {
      isRecording = true;
      update();
      getPathAudio = await utilsController.startRecord();
      if (Platform.isWindows) {
        utilsController.showSnackBarGet("message".tr, "startrecording".tr);
      } else {
        utilsController.showToastFromNative("startrecording".tr, 1);
      }
    } else {
      stopRecord();
      isRecording = false;
      isPaused = false;
      update();
      if (Platform.isWindows) {
        utilsController.showSnackBarGet("message".tr, "recordsave".tr);
      } else {
        utilsController.showToastFromNative("recordsave".tr, 1);
      }
    }
  }

  Future checkImage() async {
    if (isPicked == false) {
      if (imagePathAdd == null) {
      } else {
        File(imagePathAdd!).deleteSync();
        imagePathAdd = null;
        if (getPathAudio == null) {
        } else {
          File(getPathAudio!).deleteSync();
        }
      }
    }
  }

  Future<void> uploadImage({required ImageSource source}) async {
    ImagePicker imagePicker = ImagePicker();

    try {
      XFile? picked = await imagePicker.pickImage(source: source);
      if (picked == null) return;
      image = File(picked.path);
      Directory duplicateFilePath = await getApplicationDocumentsDirectory();
      String dirPathCurrent = duplicateFilePath.path;
      String filename = basename(picked.path);
      Directory images = Directory("$dirPathCurrent/images");
      images.createSync();
      newImage = await image!.copy("${images.path}/$filename");
      if (Platform.isWindows) {
      } else {
        await image!.delete();
      }
      imagePathAdd = newImage!.path;
      UtilsController().showToastFromNative("imageupload".tr, 1);
      update();
      Get.back();
    } on PlatformException catch (e) {
      Get.defaultDialog(
        title: "message".tr,
        content: Text("${e.message}", style: const TextStyle(fontSize: 17)),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK")),
        ],
      );
    }
  }

  @override
  void onClose() {
    checkImage();
    super.onClose();
  }
}
