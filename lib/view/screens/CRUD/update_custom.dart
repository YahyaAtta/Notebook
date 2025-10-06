import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/view/widgets/custom_change_color.dart';
import 'package:note_book/view/widgets/custom_preview.dart';
import 'package:note_book/view/widgets/custom_text_change.dart';

class UpdateCustom extends StatelessWidget {
  UpdateCustom({super.key});
  final NoteController notes = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("customizeAdd".tr),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body: ListView(
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("contentfontsizeupdate".tr),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      notes.incrementFont();
                    },
                    icon: const Icon(Icons.add_rounded)),
                GetBuilder<NoteController>(
                  builder: (c) =>
                      Text("${notes.fs}", style: const TextStyle(fontSize: 18)),
                ),
                IconButton(
                    onPressed: () {
                      notes.decrementFont();
                    },
                    icon: const Icon(Icons.remove)),
              ],
            ),
            Text("contentfontstyleupdate".tr),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: () {
                      notes.setFontStyle(FontStyle.normal);
                    },
                    child: Text("normal".tr)),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () {
                      notes.setFontStyle(FontStyle.italic);
                    },
                    child: Text("italic".tr)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("contentfontweightupdate".tr),
            CustomTextChangeStyle(),
            Text("color".tr),
            const SizedBox(
              height: 10,
            ),
            GetBuilder<NoteController>(
              builder: (controller) => Card(
                color: Color(notes.noteColor!),
                margin: const EdgeInsets.all(20),
                elevation: 30,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: GetBuilder<NoteController>(
                        builder: (c) => CustomUpdatePreview()),
                  ),
                ),
              ),
            ),
            CustomChangeColor(),
          ]),
        ],
      ),
    );
  }
}
