import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/read_controller.dart';

class PlayerWidget extends StatelessWidget {
  PlayerWidget({super.key});
  final readController = Get.find<ReadController>();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: GetBuilder<ReadController>(
                    builder: (c) => Slider(
                      onChanged: (v) async {
                        readController.onChangedUser(v);
                      },
                      onChangeEnd: (newValue) async {
                        readController.onChangedEndUser(newValue);
                      },
                      min: 0.0,
                      max: readController.duration!.inSeconds.toDouble(),
                      activeColor: Colors.orange[700],
                      value: readController.value,
                    ),
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
                      color: const Color.fromARGB(255, 177, 133, 1),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(Icons.play_arrow_outlined),
                    onPressed: () async {
                      readController.onPlayPressed();
                    },
                    tooltip: 'Play',
                  ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 177, 133, 1),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () async {
                      readController.onPausedPressed();
                    },
                    tooltip: 'Pause',
                  ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 177, 133, 1),
                      shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      readController.onStopPressed();
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
            GetBuilder<ReadController>(
                builder: (c) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            readController.getCurrentDuration,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(readController.totalDuration),
                        ),
                      ],
                    )),
          ],
        ));
  }
}
