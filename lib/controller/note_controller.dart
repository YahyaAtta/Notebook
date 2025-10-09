import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/utils_controller.dart';
import 'package:note_book/model/data_source/sqflite_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteController extends GetxController {
  late PageController pageController;
  int selectedIndex = 0;
  SqlDB sqldb = SqlDB();
  String fontStyleString = "normal";
  FontStyle fontStyle = FontStyle.normal;
  double fs = 23;
  FontWeight fontWeight = FontWeight.normal;
  String fontWeightString = "normal";
  String groupValue = "Color";
  String value = "Red";
  String value2 = "Purple";
  String value3 = "Orange";
  String value4 = "Yellow";
  String value5 = "Violent";
  void setFontStyle(FontStyle f) {
    fontStyle = f;
    if (fontStyle == FontStyle.normal) {
      fontStyleString = "normal";
    } else {
      fontStyleString = "italic";
    }
    update();
  }

  void getRefresh() {
    update();
  }

  void setFontWeight(FontWeight w) {
    fontWeight = w;
    if (fontWeight == FontWeight.normal) {
      fontWeightString = "normal";
    } else {
      fontWeightString = "bold";
    }
    update();
  }

  Future<void> initalizeApp(BuildContext context) async {
    await sqldb.initDB().then((value) {
      //AppLogic.goHome(context);
    });
  }

  void incrementFont() {
    if (fs > 1) {
      fs += 2;
      update();
    }
  }

  double get getContentSize {
    return fs;
  }

  void decrementFont() {
    if (fs > 1) {
      fs -= 2;
      update();
    }
  }

  String _contentType = "Personal";
  String get getContentType {
    return _contentType;
  }

  void setContentType(String content) {
    _contentType = content;
  }

  int? _index = 0;
  int get getIndex {
    return _index!;
  }

  void setIndex(int val) {
    _index = val;
    update();
  }

  void changeIndex(int val) {
    _index = val;
    switch (_index) {
      case 0:
        {
          changeContentType("Personal");
          changeColor(Colors.green[600]);
        }
        break;
      case 1:
        {
          changeContentType("Study");
          changeColor(Colors.blueAccent);
        }
        break;
      case 2:
        {
          changeContentType("Work");
          changeColor(Colors.teal);
        }
        break;
      case 3:
        {
          changeContentType("UnCategories");
          changeColor(Color.fromARGB(255, 164, 147, 1));
        }
        break;
    }
    update();
  }

  void changeContentType(String val) {
    _contentType = val;
    update();
  }

  List _notesDb = [];
  List get getNotes {
    return _notesDb;
  }

  int? noteColor = Colors.green[600]!.toARGB32();
  ImagePicker imagePicker = ImagePicker();
  Future<void> addNote(
      {String? noteTitle,
      String? noteContent,
      String? contentType,
      int? contentIndex,
      String? noteImageurl,
      int? noteColor,
      double? contentSize,
      String? noteDate,
      String? noteTime,
      String? fontStyle,
      String? fontWeight,
      String? noteRecord}) async {
    try {
      int r = await sqldb.insertData(
          '''INSERT INTO `notes`(`noteTitle`,`noteContent`,`contentType`,`contentIndex`,`noteImageUrl`,`noteColor`,`contentSize`,`noteDate`,`noteTime`,`fontStyle`,`fontWeight`,`noteRecord`) VALUES("$noteTitle","$noteContent","$contentType",$contentIndex,"$noteImageurl",${noteColor ?? 4292332503},$contentSize,"$noteDate","$noteTime","$fontStyle","$fontWeight","${noteRecord ?? "empty"}")''');
      if (r > 0) {
        await sqldb.readData('''
SELECT * FROM notes ORDER BY date DESC''');
        setIndex(0);
        fs = 23;
        setContentType("Personal");
        noteTitle = "";
        noteContent = "";
        noteImageurl = null;
        this.noteColor = Colors.green[600]!.toARGB32();
        fontStyleString = "normal";
        fontWeightString = "normal";
        Get.back();
        update();
        UtilsController().showToastFromNative("noteAdd".tr, 1);
      }
    } on DatabaseException catch (e) {
      Get.defaultDialog(
        title: "Message",
        content: Text("$e", style: const TextStyle(fontSize: 17)),
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

  Future<List<Map<String, Object?>>> getNotesFromDB() async {
    _notesDb = await sqldb.readData('''
    SELECT * FROM notes ORDER BY date DESC
    ''');
    return await sqldb.readData('''
    SELECT * FROM notes ORDER BY date DESC
    ''');
  }

  Future<List> getNotesFromDBStudy() async {
    _notesDb = await sqldb.readData('''
    SELECT * FROM notes  WHERE contentType='Study' ORDER BY date DESC
    ''');
    return _notesDb;
  }

  Future<void> updateNote(
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
    try {
      noteImageurl ??= noteImageurl!;
      int r = await sqldb.updateData('''
UPDATE `notes` SET noteTitle ="$noteTitle",noteContent = "$noteContent",contentType="$contentType",contentIndex=$contentIndex,noteImageUrl="$noteImageurl" , noteColor =$noteColor , contentSize=$contentSize , fontStyle="$fontStyle",fontWeight="$fontWeight"  WHERE noteId = $noteId
''');
      if (r > 0) {
        await sqldb.readData("SELECT * FROM notes ORDER BY date DESC");
        Get.back();
        update();
        UtilsController().showToastFromNative("noteUpdate".tr, 1);
      }
    } on DatabaseException catch (e) {
      Get.defaultDialog(
        title: "Message",
        content: Text("$e", style: const TextStyle(fontSize: 17)),
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

  Future<void> deleteNote(
      {int? noteId, String? noteImageurl, String? noteRecord}) async {
    try {
      if (noteRecord != "empty") {
        await File(noteRecord!).delete();
      }
      if (noteImageurl != "empty") {
        await File(noteImageurl!).delete();
      }
      int r =
          await sqldb.deleteData("DELETE FROM `notes` WHERE noteId =$noteId");
      if (r > 0) {
        UtilsController().showToastFromNative("noteDelete".tr, 1);
        _notesDb =
            await sqldb.readData("SELECT * FROM notes ORDER BY date DESC");
      }
      update();
    } on DatabaseException catch (e) {
      Get.defaultDialog(
        title: "Message",
        content: Text(e.toString(), style: const TextStyle(fontSize: 17)),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK")),
        ],
      );
    } on FileSystemException catch (e) {
      Get.defaultDialog(
        title: "Message",
        content: Text(e.message, style: const TextStyle(fontSize: 17)),
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

  void changeColor(Color? color) {
    noteColor = color!.toARGB32();
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
