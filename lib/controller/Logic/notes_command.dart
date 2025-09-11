// ignore_for_file: use_build_context_synchronously, file_names, strict_top_level_inference

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:note_book/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/controller/Logic/sqflite_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesModel extends ChangeNotifier {
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
  set setFontStyle(f) {
    fontStyle = f;
    if (fontStyle == FontStyle.normal) {
      fontStyleString = "normal";
    } else {
      fontStyleString = "italic";
    }
    notifyListeners();
  }

  set setFontWeight(w) {
    fontWeight = w;
    if (fontWeight == FontWeight.normal) {
      fontWeightString = "normal";
    } else {
      fontWeightString = "bold";
    }
    notifyListeners();
  }

  Future<void> initalizeApp(BuildContext context) async {
    await sqldb.initDB().then((value) {
      AppRoute.goHome(context);
    });
  }

  void incrementFont() {
    fs += 2;
    notifyListeners();
  }

  double get getContentSize {
    return fs;
  }

  void decrementFont() {
    fs -= 2;
    notifyListeners();
  }

  String _contentType = "Personal";
  String get getContentType {
    return _contentType;
  }

  set setContentType(content) {
    _contentType = content;
  }

  int? _index = 0;
  int get getIndex {
    return _index!;
  }

  set setIndex(val) {
    _index = val;
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
          changeColor(Colors.grey[700]);
        }
        break;
    }
    notifyListeners();
  }

  void changeContentType(String val) {
    _contentType = val;
    notifyListeners();
  }

  List _notesDb = [];
  List get getNotes {
    return _notesDb;
  }

  File? image;
  File get getImage {
    return image!;
  }

  File? newImage;
  File get getNewImage {
    return newImage!;
  }

  String? imageurl;
  String? editImageurl;
  int? noteColor = Colors.green[600]!.toARGB32();
  ImagePicker imagePicker = ImagePicker();
  Future<void> addNote(
      {required BuildContext context,
      String? noteTitle,
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
      imageurl ??= notebookLogo;
      int r = await sqldb.insertData(
          '''INSERT INTO `notes`(`noteTitle`,`noteContent`,`contentType`,`contentIndex`,`noteImageUrl`,`noteColor`,`contentSize`,`noteDate`,`noteTime`,`fontStyle`,`fontWeight`,`noteRecord`) VALUES("$noteTitle","$noteContent","$contentType",$contentIndex,"$noteImageurl",${noteColor ?? 4292332503},$contentSize,"$noteDate","$noteTime","$fontStyle","$fontWeight","${noteRecord ?? "empty"}")''');
      if (r > 0) {
        AppRoute.goBack(context);
        await sqldb.readData('''
SELECT * FROM notes ORDER BY date DESC''');
        newImage = null;
        setIndex = 0;
        fs = 23;
        fontStyleString = "normal";
        setFontStyle = FontStyle.normal;
        fontWeightString = "normal";
        setFontWeight = FontWeight.normal;
        this.noteColor = Colors.green[600]!.toARGB32();
        setContentType = "Personal";
        imageurl = null;
        noteRecord = "empty";
        notifyListeners();
      }
    } on DatabaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content: Text("$e", style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
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
      {required BuildContext context,
      String? noteTitle,
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
        editImageurl = null;
        imageurl = null;
        newImage = null;
        setIndex = 0;
        fs = 23;
        setContentType = "Personal";
        this.noteColor = Colors.green[600]!.toARGB32();
        fontStyleString = "normal";
        AppRoute.goBack(context);
      }
      notifyListeners();
    } on DatabaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content: Text("$e", style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    }
  }

  void refresh() {
    notifyListeners();
  }

  Future<void> deleteNote(
      {required BuildContext context,
      int? noteId,
      String? noteImageurl,
      String? noteRecord}) async {
    try {
      if (noteImageurl == null ||
          noteImageurl == notebookLogo ||
          noteRecord == "empty") {
      } else {
        await File(noteImageurl).delete();
        await File(noteRecord!).delete();
      }
      int r =
          await sqldb.deleteData("DELETE FROM `notes` WHERE noteId =$noteId");
      if (r > 0) {
        _notesDb =
            await sqldb.readData("SELECT * FROM notes ORDER BY date DESC");
      }
      notifyListeners();
    } on DatabaseException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content: Text("$e", style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    } on FileSystemException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content: Text(e.message, style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    }
  }

  Future<void> uploadImage(BuildContext context,
      {required ImageSource source}) async {
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
      imageurl = newImage!.path;
      notifyListeners();
      AppRoute.goBack(context);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content:
                  Text("${e.message}", style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    }
  }

  Future<void> editUploadImage(
      {required BuildContext context,
      String? noteImageUrl,
      required ImageSource source}) async {
    try {
      XFile? picked = await imagePicker.pickImage(source: source);
      if (picked == null) return;
      if (noteImageUrl != null) {
        if (noteImageUrl == notebookLogo) {
        } else {
          await File(noteImageUrl).delete();
        }
      }
      image = File(picked.path);
      Directory duplicateFilePath = await getApplicationDocumentsDirectory();
      String dirPathCurrent = duplicateFilePath.path;
      String filename = basename(picked.path);
      newImage = await image!.copy("$dirPathCurrent/$filename");
      if (Platform.isWindows) {
      } else {
        await File(picked.path).delete();
      }
      editImageurl = newImage!.path;
      notifyListeners();
      AppRoute.goBack(context);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.warning_rounded, size: 50),
              title: const Text("Message"),
              content:
                  Text("${e.message}", style: const TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                    onPressed: () {
                      AppRoute.goBack(context);
                    },
                    child: const Text("OK")),
              ],
            );
          });
    }
  }

  void changeColor(Color? color) {
    noteColor = color!.toARGB32();
    notifyListeners();
  }
}
