// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_book/controller/utils_controller.dart';
import 'package:note_book/model/data_static/assets_model.dart';
import 'package:note_book/controller/update_note_controller.dart';

class UpdateNote extends StatelessWidget {
  UpdateNote({super.key});
  final updateController =
      Get.lazyPut(() => UpdateNoteController(), fenix: true);
  final UpdateNoteController updateNoteController =
      Get.find<UpdateNoteController>();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateNoteController>(builder: (c) {
      return c.editImageUrl == null
          ? const Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
              bottomNavigationBar: NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                indicatorColor: c.controller.getIndex == 0
                    ? Colors.green[300]
                    : c.controller.getIndex == 1
                        ? Colors.blue[300]
                        : c.controller.getIndex == 2
                            ? Colors.teal[300]
                            : Colors.grey[500],
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
                          size: 30, color: Colors.indigo),
                      label: 'work'.tr),
                  NavigationDestination(
                      icon: Icon(Icons.category_rounded,
                          size: 30,
                          color: const Color.fromARGB(255, 164, 147, 1)),
                      label: 'others'.tr),
                ],
                selectedIndex: c.controller.getIndex,
                onDestinationSelected: (val) {
                  c.controller.changeIndex(val);
                  c.getRefresh();
                },
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text("updatenote".tr),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        formState.currentState!.save();
                        c.updateNoteToDatabase(
                            noteImageurl:
                                c.editImageUrl ?? c.note!.noteImageUrl,
                            noteTitle: c.editNoteTitle ?? c.note!.noteTitle,
                            noteContent:
                                c.editNoteContent ?? c.note!.noteContent,
                            noteColor: c.controller.noteColor,
                            noteId: c.note!.noteId,
                            contentType: c.controller.getContentType,
                            contentIndex: c.controller.getIndex,
                            contentSize: c.controller.fs,
                            fontStyle: c.controller.fontStyleString,
                            fontWeight: c.controller.fontWeightString);

                        c.getRefresh();
                        formState.currentState!.reset();
                      }
                    },
                    icon: const Icon(Icons.done_rounded, size: 28),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed('/customupdate');
                    },
                    icon: const Icon(Icons.dashboard_customize, size: 33),
                    tooltip: 'customizeAdd'.tr,
                  ),
                ],
              ),
              body: Form(
                key: formState,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        UtilsController().chooseImage(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          title: "updateimage".tr,
                          onCamera: () {
                            updateNoteController.editUploadImage(
                                source: ImageSource.camera);
                          },
                          cameraContent: 'fromcamera'.tr,
                          onGallery: () {
                            updateNoteController.editUploadImage(
                                source: ImageSource.gallery);
                          },
                          galleryContent: 'fromgallery'.tr,
                        );
                      },
                      child: GetBuilder<UpdateNoteController>(
                        builder: (c) => (updateNoteController.editImageUrl ==
                                        null ||
                                    updateNoteController.editImageUrl ==
                                        "empty") &&
                                (updateNoteController.note!.noteImageUrl ==
                                        "empty" ||
                                    // ignore: unnecessary_null_comparison
                                    updateNoteController.note!.noteImageUrl ==
                                        null)
                            ? Image.asset(
                                AssetsImageModel.notebook,
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Image.file(
                                File(updateNoteController.editImageUrl!),
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                width: MediaQuery.of(context).size.width,
                              ),
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
                          c.editNoteTitle = val;
                        },
                        initialValue: updateNoteController.note!.noteTitle,
                        decoration: InputDecoration(
                            hintText: 'title'.tr,
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
                            fontSize: updateNoteController.controller.fs,
                            fontStyle: updateNoteController
                                        .controller.fontStyleString ==
                                    "normal"
                                ? FontStyle.normal
                                : FontStyle.italic,
                            fontWeight: updateNoteController
                                        .controller.fontWeightString ==
                                    "normal"
                                ? FontWeight.normal
                                : FontWeight.bold),
                        onSaved: (val) {
                          c.editNoteContent = val;
                        },
                        initialValue: updateNoteController.note!.noteContent,
                        decoration: InputDecoration(
                            hintText: 'content'.tr,
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
