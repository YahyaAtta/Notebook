import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/note_controller.dart';

class CustomChangeColor extends StatelessWidget {
  CustomChangeColor({super.key});
  final NoteController notes = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
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
          ),
          IconButton(
            onPressed: () {
              notes.changeColor(Colors.grey[900]);
            },
            icon: Icon(Icons.circle_rounded, size: 50, color: Colors.grey[900]),
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
          ),
          IconButton(
            onPressed: () {
              notes.changeColor(Colors.orange);
            },
            icon: const Icon(Icons.circle_rounded,
                size: 50, color: Colors.orange),
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
          ),
        ],
      ),
    );
  }
}
