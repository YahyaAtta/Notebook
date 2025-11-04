// ignore_for_file: must_be_immutable, duplicate_ignore
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/model/data_static/assets_model.dart';
import 'package:note_book/view/screens/about_us.dart';
import 'package:note_book/model/notes.dart';
import 'package:note_book/view/screens/search_bar.dart';
import 'package:note_book/view/widgets/custom_text.dart';
import '../widgets/notebook.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final NoteController noteController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addnote');
        },
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/time');
            },
            icon: Icon(Icons.timer_rounded, size: 30),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchNotes());
            },
            icon: Icon(Icons.search_rounded, size: 30),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: Icon(Icons.settings, size: 30),
          ),
        ],
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: () {
                Get.to(() => About(), transition: Transition.size);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  AssetsImageModel.notebook,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            const SizedBox(width: 10),
            CustomText(
              data: "home".tr,
              style: TextStyle(letterSpacing: 2.5, fontSize: 24),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              "featured".tr,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          GetBuilder<NoteController>(
            builder: (c) => FutureBuilder(
              future: noteController.getNotesFromDBStudy(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("")],
                      ),
                    );
                  }
                  return Container(
                    height: 221,
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: noteController.pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return Stack(
                              children: [
                                GestureDetector(
                                  child: Card(
                                    color:
                                        snapshot.data[i]['noteImageUrl'] ==
                                            "empty"
                                        ? Color(snapshot.data[i]['noteColor'])
                                        : null,
                                    child:
                                        snapshot.data[i]['noteImageUrl'] ==
                                            "empty"
                                        ? Opacity(
                                            opacity: 0.0,
                                            child: Image.asset(
                                              AssetsImageModel.notebook,
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  3.21,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  1,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.file(
                                            File(
                                              snapshot.data[i]['noteImageUrl'],
                                            ),
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height /
                                                3.21,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                1,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  onTap: () {
                                    Get.toNamed(
                                      '/readnote',
                                      arguments: Note.fromJson(
                                        snapshot.data[i],
                                      ),
                                    );
                                  },
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 33,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xffd5b001),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        snapshot.data[i]['noteTitle'],
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () async {
                                          await noteController.pageController
                                              .previousPage(
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                                curve: Curves.easeInOutSine,
                                              );
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          size: 38,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        onPressed: () async {
                                          await noteController.pageController
                                              .nextPage(
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                                curve: Curves.easeInOutSine,
                                              );
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          size: 38,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text(""));
              },
            ),
          ),
          GetBuilder<NoteController>(
            builder: (c) => FutureBuilder(
              future: noteController.getNotesFromDB(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 5.5,
                          ),
                          const Icon(Icons.note_alt_rounded, size: 100),
                          Text(
                            "nodata".tr,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (context, i) {
                        return const SizedBox(height: 20);
                      },
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return Dismissible(
                          key: Key("$i"),
                          onDismissed: (d) async {
                            AwesomeDialog(
                              context: context,
                              dismissOnTouchOutside: false,
                              headerAnimationLoop: true,
                              animType: AnimType.scale,
                              descTextStyle: const TextStyle(fontSize: 17.0),
                              dialogType: DialogType.question,
                              title: "message".tr,
                              desc: 'messagebody'.tr,
                              btnOkText: 'option1'.tr,
                              btnCancelText: 'option2'.tr,
                              showCloseIcon: true,
                              isDense: true,
                              dialogBorderRadius: BorderRadius.circular(35),
                              onDismissCallback: (s) {
                                if (s.name == "topIcon") {
                                  noteController.getRefresh();
                                }
                              },
                              btnOkOnPress: () {
                                noteController.deleteNote(
                                  noteId: snapshot.data[i]['noteId'],
                                  noteImageurl:
                                      snapshot.data[i]['noteImageUrl'],
                                  noteRecord: snapshot.data[i]['noteRecord'],
                                );
                              },
                              btnCancelOnPress: () {
                                noteController.getRefresh();
                              },
                            ).show();
                          },
                          background: Card(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Notesbook(
                            notesbook: Note.fromJson(snapshot.data[i]),
                          ),
                        );
                      },
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
