import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/model/notes.dart';
import '../widgets/notebook.dart';

class SearchNotes extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return GetBuilder<NoteController>(
          builder: (controller) => FutureBuilder(
                future: controller.getNotesFromDB(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_alt_rounded,
                              size: 100,
                            ),
                            Text(
                              "nodata".tr,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, i) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
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
                                    controller.getRefresh();
                                  }
                                },
                                btnOkOnPress: () {
                                  controller.deleteNote(
                                      noteId: snapshot.data[i]['noteId'],
                                      noteImageurl: snapshot.data[i]
                                          ['noteImageUrl']);
                                },
                                btnCancelOnPress: () {
                                  controller.getRefresh();
                                },
                              ).show();
                            },
                            child: Notesbook(
                                notesbook: Note.fromJson(snapshot.data[i])),
                          );
                        },
                      );
                    }
                  }
                  return const Text("");
                },
              ));
    } else {
      return GetBuilder<NoteController>(builder: (controller) {
        List filter = controller.getNotes
            .where((element) =>
                element['noteTitle'].contains(query) ||
                element['noteContent'].contains(query))
            .toList();
        return filter.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_rounded,
                    size: 100,
                  ),
                  Text(
                    "nodata".tr,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  )
                ],
              ))
            : ListView.separated(
                itemCount: filter.length,
                separatorBuilder: (context, i) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, i) {
                  return Notesbook(notesbook: Note.fromJson(filter[i]));
                },
              );
      });
    }
  }
}
