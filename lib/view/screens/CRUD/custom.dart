import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/view/widgets/custom_change_color.dart';
import 'package:note_book/view/widgets/custom_preview.dart';
import 'package:note_book/view/widgets/custom_text_change.dart';

class Custom extends StatelessWidget {
  Custom({super.key});
  final NoteController customController = Get.find();
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
            Text("contentfontsize".tr),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      customController.incrementFont();
                    },
                    icon: const Icon(Icons.add_rounded)),
                GetBuilder<NoteController>(
                  builder: (c) =>
                      Text("${c.fs}", style: const TextStyle(fontSize: 18)),
                ),
                IconButton(
                    onPressed: () {
                      customController.decrementFont();
                    },
                    icon: const Icon(Icons.remove)),
              ],
            ),
            Text("contentfontstyle".tr),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: () {
                      customController.setFontStyle(FontStyle.normal);
                    },
                    child: Text("normal".tr)),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () {
                      customController.setFontStyle(FontStyle.italic);
                    },
                    child: Text("italic".tr)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("contentfontweight".tr),
            CustomTextChangeStyle(),
            const SizedBox(
              height: 10,
            ),
            Text("color".tr),
            GetBuilder<NoteController>(
                builder: (c) => Card(
                      color: Color(c.noteColor!),
                      margin: const EdgeInsets.all(20),
                      elevation: 30,
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                          child: CustomPreview(),
                        ),
                      ),
                    )),
            CustomChangeColor(),
          ]),
        ],
      ),
    );
  }
}
