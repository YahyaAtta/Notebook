import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class RealTime extends StatelessWidget {
  final Object? hour;
  final Object? minute;
  final Object? second;
  const RealTime(
      {super.key,
      required this.hour,
      required this.minute,
      required this.second});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time_filled_rounded,
            size: 100,
          ),
          Text(
            "$hour:$minute:$second",
            style: const TextStyle(fontSize: 35),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
              "${"currentdate".tr}:${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
              style: const TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}
