import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_book/main.dart';
import 'package:note_book/model/notes.dart';

// ignore: must_be_immutable
class Readnote extends StatelessWidget {
  final Notes note;
  const Readnote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Note"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Center(
                    child: note.noteImageUrl == notebookLogo
                        ? Image.asset(
                            notebookLogo,
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Image.file(
                            File(note.noteImageUrl),
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                          )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectionArea(
                    selectionControls: Platform.isWindows
                        ? DesktopTextSelectionControls()
                        : MaterialTextSelectionControls(),
                    child: Text(note.noteTitle,
                        style: const TextStyle(
                            fontSize: 33, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                child: SelectionArea(
                  selectionControls: Platform.isWindows
                      ? DesktopTextSelectionControls()
                      : MaterialTextSelectionControls(),
                  child: Text(note.noteContent,
                      style: TextStyle(
                          fontSize: note.contentSize,
                          fontWeight: note.fontWeight == "normal"
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontStyle: note.fontStyle == "normal"
                              ? FontStyle.normal
                              : FontStyle.italic)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
