import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart';

import '../model/notes.dart';

class UpdateNoteController extends GetxController {
  bool ispicked = false;
  Note? note;
  File? image;
  File? newImage;
  String? editImageUrl;
  String? userPicked;
  String? editNoteContent;
  NoteController controller = Get.find<NoteController>();
  String? editNoteTitle;
  Future updateNoteToDatabase(
      {String? noteTitle,
      String? noteContent,
      String? contentType,
      int? contentIndex,
      String? noteImageurl,
      int? noteColor,
      int? noteId,
      double? contentSize,
      String? fontStyle,
      String? fontWeight}) async {
    ispicked = true;
    // Check if user selected image
    if (ispicked == true) {
      if (userPicked == null) {
      } else {
        await File(note!.noteImageUrl).delete();
      }
    }
    controller.updateNote(
        noteTitle: noteTitle,
        noteContent: noteContent,
        contentIndex: contentIndex,
        contentSize: contentSize,
        contentType: contentType,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        noteColor: noteColor,
        noteId: noteId,
        noteImageurl: noteImageurl);
  }

  void getRefresh() {
    update();
  }

  Future fetchData() async {
    note = Get.arguments;
    update();
    if (note == null) {
    } else {
      controller.setContentType(note!.contentType);
      controller.setIndex(note!.contentIndex);
      controller.fs = note!.contentSize;
      controller.noteColor = note!.noteColor;
      editImageUrl = note!.noteImageUrl;
      controller.fontStyleString = note!.fontStyle;
      controller.fontWeightString = note!.fontWeight;
      update();
    }
  }

  Future<void> editUploadImage(
      {String? noteImageUrl, required ImageSource source}) async {
    ImagePicker imagePicker = ImagePicker();
    try {
      XFile? picked = await imagePicker.pickImage(source: source);
      if (picked == null) return;
      int r = Random().nextInt(1000000000);
      image = File(picked.path);
      Directory duplicateFilePath = await getApplicationDocumentsDirectory();
      String dirPathCurrent = "${duplicateFilePath.path}/images";
      String filename = "$r${basename(picked.path)}";
      newImage = await image!.copy("$dirPathCurrent/$filename");
      if (Platform.isWindows) {
      } else {
        await image!.delete();
      }
      editImageUrl = newImage!.path;
      userPicked = newImage!.path;
      //showToastFromNative("Image Uploded!", 1);
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
              child: Text("ok".tr)),
        ],
      );
    }
  }

  Future checkImage() async {
    if (ispicked == false) {
      if (userPicked == null) {
      } else {
        File(userPicked!).deleteSync();
      }
    }
  }

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }

  @override
  void onClose() {
    checkImage();
    super.onClose();
  }
}
