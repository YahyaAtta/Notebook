// ignore_for_file: must_be_immutable, duplicate_ignore

import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/sqflite_db_provider.dart';
import 'package:note_book/main.dart';
import 'package:note_book/view/CRUD/add_note.dart';
import 'package:note_book/view/CRUD/update_note.dart';
import 'package:note_book/view/CRUD/read_note.dart';
import 'package:note_book/view/Home/about_us.dart';
import 'package:note_book/view/Home/current_time.dart';
import 'package:note_book/view/Home/search_bar.dart';
import 'package:note_book/controller/Animation/app_animate.dart';
import 'package:note_book/model/notes.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:provider/provider.dart';

int selectedIndex = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Notesbook extends StatelessWidget {
  final Notes notesbook;
  const Notesbook({super.key, required this.notesbook});
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        AppLogic.goReadNote(context, ReadNote(note: notesbook));
      },
      onLongPress: () {
        AppLogic.goEditNote(context, UpdateNote(notes: notesbook));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
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
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     margin: const EdgeInsets.all(10),
              //     height: 80,
              //     decoration: BoxDecoration(
              //       color: Color(notesbook.noteColor),
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color(notesbook.noteColor),
              //           blurRadius: 5,
              //         ),
              //         BoxShadow(
              //           color: Color(notesbook.noteColor),
              //           blurRadius: 5,
              //         ),
              //       ],
              //       gradient: LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [Color(notesbook.noteColor), Colors.black],
              //       ),
              //     ),
              //   ),
              // ),
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
                                    notebookLogo,
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: () {
                Navigator.of(context).push(Size(page: const About()));
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    notebookLogo,
                    height: 50,
                    width: 50,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Notebook",
                style: TextStyle(letterSpacing: 2.5, fontSize: 24)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchNotes());
            },
            tooltip: 'Search',
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(Slide(page: const CurrentTime()));
              },
              tooltip: 'Current Time',
              icon: const Icon(Icons.access_time_filled)),
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Alert"),
                        content: Text("Do You Want to Reset The App?"),
                        icon: Icon(Icons.warning_rounded),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                bool isCleared =
                                    await sharedPreferences!.clear();
                                SqlDB sqlDB = SqlDB();
                                List? getNotes = await sqlDB
                                    .readData("SELECT * FROM `notes`");
                                for (int i = 0; i < getNotes.length; i++) {
                                  if (getNotes[i]['noteRecord'] != "empty") {
                                    await File(getNotes[i]['noteRecord'])
                                        .delete();
                                  }
                                  if (getNotes[i]['noteImageUrl'] != "empty") {
                                    await File(getNotes[i]['noteImageUrl'])
                                        .delete();
                                  }
                                }
                                int r = await sqlDB
                                    .deleteData("DELETE FROM `notes`");
                                if (isCleared == true && (r > 0 || r == 0)) {
                                  exit(0);
                                }
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No"))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.restore))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppLogic.goAddNote(context, const AddNote());
          },
          child: const Icon(Icons.add_rounded)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Text("Featured",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Consumer<NoteController>(
            builder: (context, notes, child) {
              return FutureBuilder(
                future: notes.getNotesFromDBStudy(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(""),
                          ],
                        ),
                      );
                    }
                    return Container(
                      height: 221,
                      margin: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    child: Card(
                                      color: snapshot.data[i]['noteImageUrl'] ==
                                              "empty"
                                          ? Color(snapshot.data[i]['noteColor'])
                                          : null,
                                      child: snapshot.data[i]['noteImageUrl'] ==
                                              "empty"
                                          ? Opacity(
                                              opacity: 0.0,
                                              child: Image.asset(
                                                notebookLogo,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3.21,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.file(
                                              File(snapshot.data[i]
                                                  ['noteImageUrl']),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.21,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    onTap: () {
                                      AppLogic.goReadNote(
                                          context,
                                          ReadNote(
                                              note: Notes.fromJson(
                                                  snapshot.data[i])));
                                    },
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 33,
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xffd5b001),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          snapshot.data[i]['noteTitle'],
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                      )
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
                                              await pageController.previousPage(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.easeInOutSine);
                                            },
                                            icon: Icon(
                                              Icons.arrow_back_ios_new_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              size: 38,
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                            onPressed: () async {
                                              await pageController.nextPage(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.easeInOutSine);
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              size: 38,
                                            )),
                                      )
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
                  return const Center(
                    child: Text(""),
                  );
                },
              );
            },
          ),
          Consumer<NoteController>(
            builder: (context, notes, child) {
              return FutureBuilder(
                future: notes.getNotesFromDB(),
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
                            const Icon(
                              Icons.note_alt_rounded,
                              size: 100,
                            ),
                            const Text(
                              "No Notes",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        separatorBuilder: (context, i) {
                          return const SizedBox(
                            height: 20,
                          );
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
                                title: "Message",
                                desc: 'Do You Want To Delete Note ?',
                                btnOkText: 'Yes',
                                btnCancelText: 'No',
                                showCloseIcon: true,
                                isDense: true,
                                dialogBorderRadius: BorderRadius.circular(35),
                                onDismissCallback: (s) {
                                  if (s.name == "topIcon") {
                                    notes.refresh();
                                  }
                                },
                                btnOkOnPress: () {
                                  notes.deleteNote(
                                      context: context,
                                      noteId: snapshot.data[i]['noteId'],
                                      noteImageurl: snapshot.data[i]
                                          ['noteImageUrl'],
                                      noteRecord: snapshot.data[i]
                                          ['noteRecord']);
                                },
                                btnCancelOnPress: () {
                                  notes.refresh();
                                },
                              ).show();
                            },
                            background: Card(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Notesbook(
                                notesbook: Notes.fromJson(snapshot.data[i])),
                          );
                        },
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
