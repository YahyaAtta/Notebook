import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/main.dart';
import 'package:note_book/view/CRUD/update_custom.dart';
import 'package:note_book/controller/Animation/app_animate.dart';
import 'package:note_book/model/notes.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:provider/provider.dart';

class UpdateNote extends StatefulWidget {
  final Notes notes;
  const UpdateNote({super.key, required this.notes});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  String? editNoteContent;
  String? editNoteTitle;

  @override
  void didChangeDependencies() {
    Provider.of<NoteController>(context, listen: false).setContentType =
        widget.notes.contentType;
    Provider.of<NoteController>(context, listen: false).setIndex =
        widget.notes.contentIndex;
    Provider.of<NoteController>(context, listen: false).fs =
        widget.notes.contentSize;
    Provider.of<NoteController>(context, listen: false).noteColor =
        widget.notes.noteColor;
    Provider.of<NoteController>(context, listen: false).editImageurl =
        widget.notes.noteImageUrl;
    Provider.of<NoteController>(context, listen: false).fontStyleString =
        widget.notes.fontStyle;
    Provider.of<NoteController>(context, listen: false).fontWeightString =
        widget.notes.fontWeight;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteController>(builder: (context, notesModel, child) {
      return notesModel.editImageurl == null
          ? const Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
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
                          size: 30, color: Colors.indigo),
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
                title: const Text("Update Note"),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        formState.currentState!.save();
                        notesModel.updateNote(
                            context: context,
                            noteImageurl: notesModel.editImageurl ??
                                widget.notes.noteImageUrl,
                            noteTitle: editNoteTitle ?? widget.notes.noteTitle,
                            noteContent: editNoteContent,
                            noteColor: notesModel.noteColor,
                            noteId: widget.notes.noteId,
                            contentType: notesModel.getContentType,
                            contentIndex: notesModel.getIndex,
                            contentSize: notesModel.fs,
                            fontStyle: notesModel.fontStyleString,
                            fontWeight: notesModel.fontWeightString);
                        formState.currentState!.reset();
                      }
                    },
                    icon: const Icon(Icons.done_rounded, size: 28),
                    tooltip: 'Update Note',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(Slide(page: const UpdateCustom()));
                    },
                    icon: const Icon(Icons.dashboard_customize, size: 33),
                    tooltip: 'Customize Note',
                  ),
                ],
              ),
              body: Form(
                key: formState,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppLogic.chooseImage(
                            context: context,
                            title: 'Update Image',
                            cameraContent: 'From Camera',
                            galleryContent: 'From Gallery',
                            onGallery: () {
                              notesModel.editUploadImage(
                                  context: context,
                                  source: ImageSource.gallery,
                                  noteImageUrl: widget.notes.noteImageUrl);
                            },
                            onCamera: () {
                              notesModel.editUploadImage(
                                context: context,
                                source: ImageSource.camera,
                                noteImageUrl: widget.notes.noteImageUrl,
                              );
                            });
                      },
                      child: notesModel.editImageurl == "empty" &&
                              widget.notes.noteImageUrl == "empty"
                          ? Image.asset(
                              notebookLogo,
                              height: MediaQuery.of(context).size.height / 3.3,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Image.file(
                              File(notesModel.editImageurl!),
                              height: MediaQuery.of(context).size.height / 3.3,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                        onSaved: (val) {
                          editNoteTitle = val;
                        },
                        initialValue: widget.notes.noteTitle,
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
                        minLines: 1,
                        maxLines: 9000000000000000,
                        style: TextStyle(
                            fontSize: notesModel.fs,
                            fontStyle: notesModel.fontStyleString == "normal"
                                ? FontStyle.normal
                                : FontStyle.italic,
                            fontWeight: notesModel.fontWeightString == "normal"
                                ? FontWeight.normal
                                : FontWeight.bold),
                        onSaved: (val) {
                          editNoteContent = val;
                        },
                        initialValue: widget.notes.noteContent,
                        decoration: const InputDecoration(
                            hintText: 'Content',
                            hintStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
