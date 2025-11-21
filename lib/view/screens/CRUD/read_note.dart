// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/read_controller.dart';
import 'package:note_book/model/data_static/assets_model.dart';
import 'package:note_book/view/widgets/player_widget.dart';
import '../../../main.dart';

// ignore: must_be_immutable
class ReadNote extends StatelessWidget {
  ReadNote({super.key});
  final ReadController readController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("readnote".tr),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("savepdf".tr),
                  onTap: () async {
                    readController.savePDFClient();
                  },
                ),
                PopupMenuItem(
                  onTap: readController.note!.noteRecord == "empty"
                      ? null
                      : () async {
                          readController.saveAudioClient();
                        },
                  child: Text("saveaudio".tr),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Get.isDarkMode
                    ? [Colors.black, Color(readController.note!.noteColor)]
                    : [Colors.white, Color(readController.note!.noteColor)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Center(
                      child: readController.note!.noteImageUrl == "empty"
                          ? Opacity(
                              opacity: 0.0,
                              child: Image.asset(
                                AssetsImageModel.notebook,
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          : Image.file(
                              File(readController.note!.noteImageUrl),
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                readController.note!.noteRecord == "empty"
                    ? Text("")
                    : PlayerWidget(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectionArea(
                    selectionControls: Platform.isWindows
                        ? DesktopTextSelectionControls()
                        : MaterialTextSelectionControls(),
                    child: Align(
                      alignment:
                          detectLanguage(readController.note!.noteTitle) ==
                              TextDirection.rtl
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Directionality(
                        textDirection:
                            detectLanguage(readController.note!.noteTitle) ==
                                TextDirection.rtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          readController.note!.noteTitle,
                          textDirection:
                              detectLanguage(readController.note!.noteTitle) ==
                                  TextDirection.rtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign: detectLang(readController.note!.noteTitle),
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                  child: SelectionArea(
                    selectionControls: Platform.isWindows
                        ? DesktopTextSelectionControls()
                        : MaterialTextSelectionControls(),
                    child: Align(
                      alignment:
                          detectLanguage(readController.note!.noteContent) ==
                              TextDirection.rtl
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Directionality(
                        textDirection:
                            detectLanguage(readController.note!.noteContent) ==
                                TextDirection.rtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          readController.note!.noteContent,
                          textDirection:
                              detectLanguage(
                                    readController.note!.noteContent,
                                  ) ==
                                  TextDirection.rtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign:
                              detectLang(readController.note!.noteContent) ==
                                  TextAlign.right
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            fontSize: readController.note!.contentSize,
                            fontWeight:
                                readController.note!.fontWeight == "normal"
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontStyle:
                                readController.note!.fontStyle == "normal"
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
