import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/time_controller.dart';
import '../widgets/real_time.dart';

class CurrentTime extends StatelessWidget {
  CurrentTime({super.key});
  final TimerController timerController =
      Get.put(TimerController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("currenttime".tr),
      ),
      body: Center(
        child: GetBuilder<TimerController>(
            builder: (controller) => RealTime(
                hour: controller.hour,
                minute: controller.minute,
                second: controller.second)),
      ),
    );
  }
}
