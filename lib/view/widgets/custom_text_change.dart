import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/note_controller.dart';

class CustomTextChangeStyle extends StatelessWidget {
  CustomTextChangeStyle({super.key});
  final NoteController notes = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              notes.setFontWeight(FontWeight.normal);
            },
            icon: const Icon(Icons.font_download)),
        IconButton(
            onPressed: () {
              notes.setFontWeight(FontWeight.bold);
            },
            icon: const Icon(Icons.font_download)),
      ],
    );
  }
}
