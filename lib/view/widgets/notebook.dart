import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/model/data_static/assets_model.dart';
import 'package:note_book/model/notes.dart';

class Notesbook extends StatelessWidget {
  final Note notesbook;
  const Notesbook({super.key, required this.notesbook});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/readnote', arguments: notesbook);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Get.isDarkMode
                    ? [
                        Color(notesbook.noteColor),
                        const Color.fromARGB(255, 48, 47, 47),
                      ]
                    : [
                        Color(notesbook.noteColor),
                        const Color.fromARGB(255, 209, 209, 209),
                      ])),
        child: Card(
          margin: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: notesbook.noteImageUrl == "empty"
                              ? Opacity(
                                  opacity: 0.0,
                                  child: Image.asset(
                                    AssetsImageModel.notebook,
                                    height: MediaQuery.of(context).size.height /
                                        4.6,
                                    width:
                                        MediaQuery.of(context).size.width / 5.5,
                                  ),
                                )
                              : Image.file(
                                  File(notesbook.noteImageUrl),
                                  height:
                                      MediaQuery.of(context).size.height / 4.6,
                                  width:
                                      MediaQuery.of(context).size.width / 5.5,
                                )))),
              Expanded(
                  flex: 5,
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          Get.toNamed("/updatenote", arguments: notesbook);
                        },
                        icon: Icon(Icons.edit_rounded)),
                    title: notesbook.noteTitle == ""
                        ? Text(notesbook.noteContent,
                            style: const TextStyle(
                                fontSize: 16.3,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis))
                        : Text(notesbook.noteTitle,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis)),
                    subtitle:
                        Text("${notesbook.noteDate}\n${notesbook.noteTime}"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
