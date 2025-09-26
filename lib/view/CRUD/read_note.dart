// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/main.dart';
import 'package:note_book/model/notes.dart';

// ignore: must_be_immutable
class ReadNote extends StatefulWidget {
  final Notes note;
  const ReadNote({super.key, required this.note});

  @override
  State<ReadNote> createState() => _ReadNoteState();
}

class _ReadNoteState extends State<ReadNote> {
  AppLogic appLogic = AppLogic();
  bool isPlaying = false;
  double value = 0.0;
  Duration? duration = const Duration(seconds: 0);
  AudioPlayer audioPlayer = AudioPlayer();
  Future initPlayer() async {
    if (widget.note.noteRecord == "empty") {
    } else {
      await audioPlayer.setSource(DeviceFileSource(widget.note.noteRecord!));
      duration = await audioPlayer.getDuration();
      setState(() {
        duration = duration;
      });
    }
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Note"),
        centerTitle: true,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Save PDF"),
                onTap: () async {
                  if ((widget.note.noteTitle.isArabic() &&
                          widget.note.noteContent.isArabic()) ||
                      (widget.note.noteTitle.isArabic() ||
                          widget.note.noteContent.isArabic())) {
                    if (Platform.isWindows) {
                      SnackBar snackBar = SnackBar(
                          content: Text("Not Supported Arabic Typing Yet"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      AppLogic().showToastFromNative(
                          "Not Supported Arabic Typing Yet", 1);
                    }
                  } else {
                    await appLogic.savePDF(
                        widget.note.noteTitle, widget.note.noteContent);
                    if (Platform.isWindows) {
                      SnackBar snackBar =
                          SnackBar(content: Text("PDF Has Been Saved"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      AppLogic().showToastFromNative("PDF Has been Saved", 1);
                    }
                  }
                },
              ),
              PopupMenuItem(
                onTap: widget.note.noteRecord == "empty"
                    ? null
                    : () async {
                        if (widget.note.noteRecord! == "empty") {
                        } else {
                          bool isExists = await AppLogic()
                              .saveAudio(widget.note.noteRecord!);
                          if (isExists == true) {
                            if (Platform.isWindows) {
                              SnackBar snackBar = SnackBar(
                                  content: Text("Audio Has been Saved"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              AppLogic().showToastFromNative(
                                  "Audio Has been Saved", 1);
                            }
                          } else {
                            if (Platform.isWindows) {
                              SnackBar snackBar =
                                  SnackBar(content: Text("No Audio File"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              AppLogic()
                                  .showToastFromNative("No Audio File", 1);
                            }
                          }
                        }
                      },
                child: Text("Save Audio"),
              ),
            ];
          }),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [
                            Colors.black,
                            Color(widget.note.noteColor),
                          ]
                        : [
                            Colors.white,
                            Color(widget.note.noteColor),
                          ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Center(
                        child: widget.note.noteImageUrl == "empty"
                            ? Opacity(
                                opacity: 0.0,
                                child: Image.asset(notebookLogo,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width),
                              )
                            : Image.file(
                                File(widget.note.noteImageUrl),
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                              )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.note.noteRecord == "empty"
                    ? Text("")
                    : Container(
                        margin: EdgeInsets.all(20),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Slider(
                                    onChanged: (v) async {
                                      if (isPlaying == true) {
                                        await audioPlayer.pause();
                                        setState(() {
                                          isPlaying = false;
                                          value = v;
                                        });
                                      } else {
                                        setState(() {
                                          isPlaying = false;
                                          value = v;
                                        });
                                      }
                                    },
                                    onChangeEnd: (newValue) async {
                                      setState(() {
                                        value = newValue;
                                        isPlaying = true;
                                      });
                                      await audioPlayer.pause();
                                      await audioPlayer.seek(
                                          Duration(seconds: newValue.toInt()));
                                      await audioPlayer.resume();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    },
                                    min: 0.0,
                                    max: duration!.inSeconds.toDouble(),
                                    activeColor: Colors.orange[700],
                                    value: value,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 177, 133, 1),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: Icon(Icons.play_arrow_outlined),
                                    onPressed: () async {
                                      await audioPlayer.resume();
                                      isPlaying = true;
                                      setState(() {});
                                      debugPrint(
                                          "Current:$value\nDuration:$duration");
                                      audioPlayer.onPositionChanged
                                          .listen((position) {
                                        setState(() {
                                          value = position.inSeconds.toDouble();
                                        });
                                      });
                                      audioPlayer.onPlayerComplete
                                          .listen((event) {
                                        setState(() {
                                          isPlaying = false;
                                          value = 0.0;
                                          audioPlayer.stop();
                                        });
                                      });
                                      setState(() {});
                                    },
                                    tooltip: 'Play',
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 177, 133, 1),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: Icon(Icons.pause),
                                    onPressed: () async {
                                      await audioPlayer.pause();
                                      isPlaying = false;
                                      setState(() {});
                                    },
                                    tooltip: 'Pause',
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 177, 133, 1),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      audioPlayer.stop();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                    icon: Icon(Icons.stop),
                                    tooltip: 'Stop',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "${(value / 60).floor() < 10 ? "0${(value / 60).floor()}" : (value / 60).floor()}:${(value % 60).floor() < 10 ? "0${(value % 60).floor()}" : (value % 60).floor()}",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      "${duration!.inMinutes < 10 ? "0${duration!.inMinutes}" : duration!.inMinutes}:${duration!.inSeconds % 60 < 10 ? "0${duration!.inSeconds % 60}" : duration!.inSeconds % 60}"),
                                ),
                              ],
                            ),
                          ],
                        )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectionArea(
                      selectionControls: Platform.isWindows
                          ? DesktopTextSelectionControls()
                          : MaterialTextSelectionControls(),
                      child: Text(widget.note.noteTitle,
                          style: const TextStyle(
                              fontSize: 33, fontWeight: FontWeight.bold))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                  child: SelectionArea(
                    selectionControls: Platform.isWindows
                        ? DesktopTextSelectionControls()
                        : MaterialTextSelectionControls(),
                    child: Text(widget.note.noteContent,
                        style: TextStyle(
                            fontSize: widget.note.contentSize,
                            fontWeight: widget.note.fontWeight == "normal"
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontStyle: widget.note.fontStyle == "normal"
                                ? FontStyle.normal
                                : FontStyle.italic)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
