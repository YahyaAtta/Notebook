import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/main.dart';
import 'package:note_book/view/CRUD/custom.dart';
import 'package:note_book/controller/Animation/app_animate.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DateTime? selectedDate;
  String? noteDate;
  String? noteTime;
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void deactivate() {
    if (Provider.of<NotesModel>(context).imageurl == null) {
    } else {
      File(Provider.of<NotesModel>(context, listen: false).imageurl!)
          .deleteSync();
      Provider.of<NotesModel>(context).imageurl = null;
      debugPrint("Deleted File");
    }
    super.deactivate();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesModel>(
      builder: (context, notesModel, child) {
        return Scaffold(
          body: Form(
            key: formState,
            child: Scaffold(
                bottomNavigationBar: NavigationBar(
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  indicatorColor: notesModel.getIndex == 0
                      ? Colors.green[300]
                      : notesModel.getIndex == 1
                          ? Colors.blue[300]
                          : notesModel.getIndex == 2
                              ? Colors.teal[300]
                              : Colors.grey[500],
                  destinations: [
                    NavigationDestination(
                        icon: Icon(Icons.person_rounded,
                            size: 30, color: Colors.green[600]),
                        label: 'Personal'),
                    const NavigationDestination(
                        icon: Icon(Icons.school_rounded,
                            size: 30, color: Colors.blueAccent),
                        label: 'Study'),
                    const NavigationDestination(
                        icon: Icon(Icons.work_rounded,
                            size: 30, color: Colors.teal),
                        label: 'Work'),
                    NavigationDestination(
                        icon: Icon(Icons.category_rounded,
                            size: 30, color: Colors.grey[900]),
                        label: 'Others'),
                  ],
                  selectedIndex: notesModel.getIndex,
                  onDestinationSelected: (val) {
                    notesModel.changeIndex(val);
                  },
                ),
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Add Note"),
                  actions: [
                    Visibility(
                      maintainAnimation: true,
                      maintainInteractivity: true,
                      maintainSemantics: true,
                      maintainSize: true,
                      maintainState: true,
                      visible: noteTitle.text == "" && noteContent.text == ""
                          ? false
                          : true,
                      child: IconButton(
                        onPressed: noteTitle.text == "" &&
                                noteContent.text == ""
                            ? null
                            : () async {
                                if (formState.currentState!.validate()) {
                                  formState.currentState!.save();
                                  getCurrentDateAndTime();
                                  notesModel.addNote(
                                      context: context,
                                      noteTitle: noteTitle.text,
                                      noteContent: noteContent.text,
                                      noteColor: notesModel.noteColor,
                                      noteTime: noteTime,
                                      noteDate: noteDate,
                                      contentSize: notesModel.getContentSize,
                                      noteImageurl:
                                          notesModel.imageurl ?? notebookLogo,
                                      contentIndex: notesModel.getIndex,
                                      contentType: notesModel.getContentType,
                                      fontStyle: notesModel.fontStyleString,
                                      fontWeight: notesModel.fontWeightString);
                                }
                              },
                        icon: const Icon(Icons.done_rounded, size: 28),
                        tooltip: noteTitle.text == "" && noteContent.text == ""
                            ? ''
                            : 'Add Note',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(Slide(page: const Custom()));
                      },
                      icon: const Icon(Icons.dashboard_customize, size: 33),
                      tooltip: 'Customize Note',
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRoute.chooseImage(
                            context: context,
                            galleryContent: 'From Gallery',
                            cameraContent: 'From Camera',
                            title: 'Choose Your Image',
                            onCamera: () {
                              notesModel.uploadImage(context,
                                  source: ImageSource.camera);
                            },
                            onGallery: () {
                              notesModel.uploadImage(context,
                                  source: ImageSource.gallery);
                            });
                      },
                      child: notesModel.newImage == null &&
                              notesModel.imageurl == null
                          ? Image.asset(
                              notebookLogo,
                              height: MediaQuery.of(context).size.height / 3.3,
                              width: MediaQuery.of(context).size.width,
                            )
                          : notesModel.imageurl == null
                              ? Image.asset(
                                  notebookLogo,
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Image.file(
                                  File(notesModel.imageurl!),
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
                                  width: MediaQuery.of(context).size.width,
                                ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (val) {
                          notesModel.refresh();
                        },
                        style: const TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                        controller: noteTitle,
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                            border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (val) {
                          notesModel.refresh();
                        },
                        style: TextStyle(
                            fontSize: notesModel.fs,
                            fontStyle: notesModel.fontStyle,
                            fontWeight: notesModel.fontWeight),
                        controller: noteContent,
                        minLines: 1,
                        maxLines: 9000000000000000,
                        decoration: const InputDecoration(
                            hintText: 'Content',
                            hintStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w400),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
