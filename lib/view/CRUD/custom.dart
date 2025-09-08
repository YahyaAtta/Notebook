import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/controller/Logic/notes_command.dart';
import 'package:provider/provider.dart';

class Custom extends StatelessWidget {
  const Custom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize"),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'Edit Done',
              onPressed: () {
                AppRoute.goBack(context);
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body: ListView(
        children: [
          Consumer<NotesModel>(
            builder: (context, notes, child) =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Content Font Size"),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        notes.incrementFont();
                      },
                      icon: const Icon(Icons.add_rounded)),
                  Text("${notes.fs}", style: const TextStyle(fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        notes.decrementFont();
                      },
                      icon: const Icon(Icons.remove)),
                ],
              ),
              const Text("Content Font Style"),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        notes.setFontStyle = FontStyle.normal;
                      },
                      child: const Text("Normal")),
                  const SizedBox(
                    width: 10,
                  ),
                  FilledButton(
                      onPressed: () {
                        notes.setFontStyle = FontStyle.italic;
                      },
                      child: const Text("Italic")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Content Font Weight"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        notes.setFontWeight = FontWeight.normal;
                      },
                      icon: const Icon(Icons.font_download)),
                  IconButton(
                      onPressed: () {
                        notes.setFontWeight = FontWeight.bold;
                      },
                      icon: const Icon(Icons.font_download)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Color"),
              Card(
                color: Color(notes.noteColor!),
                margin: const EdgeInsets.all(20),
                elevation: 30,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Text("Preview",
                        style: TextStyle(
                            fontSize: notes.fs,
                            fontStyle: notes.fontStyle,
                            fontWeight: notes.fontWeight)),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Consumer<NotesModel>(
                  builder: (context, notes, child) => ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      IconButton(
                        onPressed: () {
                          notes.changeColor(const Color(0xffFFCF15));
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Color(0xffFFCF15),
                        ),
                        tooltip: 'NoteBook Color',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.green[600]);
                        },
                        icon: Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.green[600],
                        ),
                        tooltip: 'Green D 600',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.blueAccent);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.blueAccent,
                        ),
                        tooltip: 'Blue Accent',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.teal);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.teal,
                        ),
                        tooltip: 'Teal',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.grey[900]);
                        },
                        icon: Icon(Icons.circle_rounded,
                            size: 50, color: Colors.grey[900]),
                        tooltip: 'Color grey 900',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.blue);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.blue,
                        ),
                        tooltip: 'Blue',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.purple);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.purple,
                        ),
                        tooltip: 'Purple',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.orange);
                        },
                        icon: const Icon(Icons.circle_rounded,
                            size: 50, color: Colors.orange),
                        tooltip: 'Orange',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.lightGreenAccent);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.lightGreenAccent,
                        ),
                        tooltip: 'Light Green',
                      ),
                      IconButton(
                        onPressed: () {
                          notes.changeColor(Colors.pink);
                        },
                        icon: const Icon(
                          Icons.circle_rounded,
                          size: 50,
                          color: Colors.pink,
                        ),
                        tooltip: 'Pink',
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
