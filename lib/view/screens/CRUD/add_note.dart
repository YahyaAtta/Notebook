// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/add_note_controller.dart';
import 'package:note_book/controller/utils_controller.dart';
import 'package:note_book/model/data_static/assets_model.dart';

class AddNote extends StatelessWidget {
  AddNote({super.key});
  final AddNoteController addNoteController = Get.put(AddNoteController());
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formState,
        child: Scaffold(
            bottomNavigationBar: GetBuilder<AddNoteController>(
                builder: (controller) => NavigationBar(
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysShow,
                      indicatorColor: addNoteController.controller.getIndex == 0
                          ? Colors.green[300]
                          : addNoteController.controller.getIndex == 1
                              ? Colors.blue[300]
                              : addNoteController.controller.getIndex == 2
                                  ? Colors.teal[300]
                                  : const Color.fromARGB(255, 57, 52, 1),
                      destinations: [
                        NavigationDestination(
                            icon: Icon(Icons.person_rounded,
                                size: 30, color: Colors.green[600]),
                            label: 'personal'.tr),
                        NavigationDestination(
                            icon: Icon(Icons.school_rounded,
                                size: 30, color: Colors.blueAccent),
                            label: 'study'.tr),
                        NavigationDestination(
                            icon: Icon(Icons.work_rounded,
                                size: 30, color: Colors.teal),
                            label: 'work'.tr),
                        NavigationDestination(
                            icon: Icon(Icons.category_rounded,
                                size: 30,
                                color: Color.fromARGB(255, 164, 147, 1)),
                            label: 'others'.tr),
                      ],
                      selectedIndex: addNoteController.controller.getIndex,
                      onDestinationSelected: (val) {
                        addNoteController.controller.changeIndex(val);
                        addNoteController.refreshGet();
                      },
                    )),
            appBar: AppBar(
              centerTitle: true,
              title: Text("addnote".tr),
              actions: [
                GetBuilder<AddNoteController>(
                    builder: (c) => Visibility(
                          maintainAnimation: true,
                          maintainInteractivity: true,
                          maintainSemantics: true,
                          maintainSize: true,
                          maintainState: true,
                          visible:
                              noteTitle.text == "" && noteContent.text == ""
                                  ? false
                                  : true,
                          child: IconButton(
                            onPressed: noteTitle.text == "" &&
                                    noteContent.text == ""
                                ? null
                                : () async {
                                    if (formState.currentState!.validate()) {
                                      formState.currentState!.save();
                                      c.getCurrentDateAndTime();
                                      c.addNoteToDatabase(
                                        noteTitle: noteTitle.text,
                                        noteContent: noteContent.text,
                                        noteColor: c.controller.noteColor,
                                        contentSize:
                                            c.controller.getContentSize,
                                        noteImageUrl: c.imagePathAdd == null
                                            ? "empty"
                                            : c.imagePathAdd!,
                                        contentIndex: c.controller.getIndex,
                                        contentType:
                                            c.controller.getContentType,
                                        fontStyle: c.controller.fontStyleString,
                                        fontWeight:
                                            c.controller.fontWeightString,
                                        noteRecord: c.getPathAudio == "empty"
                                            ? "empty"
                                            : c.getPathAudio,
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.done_rounded, size: 28),
                            tooltip:
                                noteTitle.text == "" && noteContent.text == ""
                                    ? ''
                                    : 'addnote'.tr,
                          ),
                        )),
                IconButton(
                  onPressed: () {
                    Get.toNamed("/custom");
                  },
                  icon: const Icon(Icons.dashboard_customize, size: 33),
                  tooltip: 'customize'.tr,
                ),
                GetBuilder<AddNoteController>(
                    builder: (c) => IconButton(
                          onPressed: () async {
                            c.onPressedStartRecording();
                          },
                          icon: addNoteController.isRecording == true
                              ? Icon(Icons.fiber_manual_record_rounded)
                              : Icon(Icons.fiber_manual_record_outlined),
                          tooltip: addNoteController.isRecording == true
                              ? 'pause'.tr
                              : 'record'.tr,
                        )),
              ],
            ),
            body: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    UtilsController().chooseImage(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        galleryContent: 'fromgallery'.tr,
                        cameraContent: 'fromcamera'.tr,
                        title: 'chooseyourimage'.tr,
                        onCamera: () {
                          if (Platform.isWindows) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    icon: Icon(
                                      Icons.info_rounded,
                                      size: 30,
                                    ),
                                    title: Text("Info"),
                                    content: Text("Coming Soon!"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK")),
                                    ],
                                  );
                                });
                          } else {
                            addNoteController.uploadImage(
                                source: ImageSource.camera);
                          }
                        },
                        onGallery: () {
                          addNoteController.uploadImage(
                              source: ImageSource.gallery);
                        });
                  },
                  child: GetBuilder<AddNoteController>(
                    builder: (c) => c.imagePathAdd == null
                        ? Image.asset(
                            AssetsImageModel.notebook,
                            height: MediaQuery.of(context).size.height / 3.3,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Image.file(
                            File(c.imagePathAdd!),
                            height: MediaQuery.of(context).size.height / 3.3,
                            width: MediaQuery.of(context).size.width,
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetBuilder<AddNoteController>(
                      builder: (c) => TextFormField(
                            onChanged: (val) {
                              addNoteController.refreshGet();
                            },
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                            controller: noteTitle,
                            decoration: InputDecoration(
                                hintText: 'title'.tr,
                                hintStyle: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                                border: InputBorder.none),
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetBuilder<AddNoteController>(
                      builder: (controller) => TextFormField(
                            onChanged: (val) {
                              addNoteController.refreshGet();
                            },
                            style: TextStyle(
                                fontSize: addNoteController.controller.fs,
                                fontStyle:
                                    addNoteController.controller.fontStyle,
                                fontWeight:
                                    addNoteController.controller.fontWeight),
                            controller: noteContent,
                            minLines: 1,
                            maxLines: 9000000000000000,
                            decoration: InputDecoration(
                                hintText: 'content'.tr,
                                hintStyle: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          )),
                ),
              ],
            )),
      ),
    );
  }
}
