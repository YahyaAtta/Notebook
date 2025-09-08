import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart' ;
import 'package:note_book/view/Home/home_screen.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:provider/provider.dart';

import 'package:note_book/model/notes.dart';

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
      return Consumer<NotesModel>(
        builder: (context, notes, child) {
          return FutureBuilder(
            future: notes.getNotesFromDB(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_alt_rounded, size: 100,),
                        Text("No Notes",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight
                              .w500),)
                      ],
                    ),
                  );
                }
                else {
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
                        onDismissed: (d) async{
                         AwesomeDialog(context: context ,
                              dismissOnTouchOutside: false,
                              headerAnimationLoop: true,
                              animType: AnimType.scale,
                              descTextStyle: const TextStyle(fontSize: 17.0),
                              dialogType: DialogType.question,
                              title: "Message" ,
                              desc: 'Do You Want To Delete Note ?' ,
                              btnOkText: 'Yes',
                              btnCancelText: 'No',
                              showCloseIcon: true,
                              isDense: true,
                              dialogBorderRadius: BorderRadius.circular(35),
                              onDismissCallback:(s){
                                if(s.name == "topIcon"){
                                  notes.refresh() ;
                                }
                              },
                              btnOkOnPress: (){
                                notes.deleteNote(context: context,noteId: snapshot.data[i]['noteId'] ,noteImageurl: snapshot.data[i]['noteImageUrl']);
                              } ,
                              btnCancelOnPress: (){
                                notes.refresh() ;
                              } ,
                            ).show();
                        },
                        child: Notesbook(
                            notesbook: Notes.fromJson(snapshot.data[i])),
                      );
                    },
                  );
                }
              }
              return const Text("");
            },
          );
        },
      );
    }
    else {
      return Consumer<NotesModel>(
        builder: (context, notes, child) {
          List filter = notes.getNotes.where((element) =>
              element['noteTitle'].contains(query) || element['noteContent'].contains(query)).toList();
          return filter.isEmpty ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_rounded, size: 100,),
                  Text("No Notes",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight
                        .w500),)
                ],
              )
          ): ListView.separated(
            itemCount: filter.length,
            separatorBuilder: (context, i) {
              return const SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, i) {
               return Notesbook(
                   notesbook: Notes.fromJson(filter[i]));
            },
          );
        },
      );
    }
  }
}