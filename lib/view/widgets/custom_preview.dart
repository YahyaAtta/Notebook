import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/note_controller.dart';

class CustomUpdatePreview extends StatelessWidget {
  CustomUpdatePreview({super.key});
  final NoteController notes = Get.find();
  @override
  Widget build(BuildContext context) {
    return Text("preview".tr,
        style: TextStyle(
            fontSize: notes.fs,
            fontStyle: notes.fontStyleString == "normal"
                ? FontStyle.normal
                : FontStyle.italic,
            fontWeight: notes.fontWeightString == "normal"
                ? FontWeight.normal
                : FontWeight.bold));
  }
}

class CustomPreview extends StatelessWidget {
  CustomPreview({super.key});
  final NoteController notes = Get.find();

  @override
  Widget build(BuildContext context) {
    return Text("preview".tr,
        style: TextStyle(
            fontSize: notes.fs,
            fontStyle: notes.fontStyle,
            fontWeight: notes.fontWeight));
  }
}
