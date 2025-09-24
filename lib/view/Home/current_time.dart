import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/time_command.dart';
import 'package:provider/provider.dart';

class CurrentTime extends StatefulWidget {
  const CurrentTime({super.key});

  @override
  State<CurrentTime> createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<CurrentTime> {
  @override
  void initState() {
    Provider.of<TimeController>(context, listen: false).getRealTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Current Time "),
      ),
      body: Center(
        child: Consumer<TimeController>(
          builder: (context, time, child) {
            return RealTime(
                hour: time.getHour,
                minute: time.getMinute,
                second: time.getSecond);
          },
        ),
      ),
    );
  }
}

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
              "Current Date :${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
              style: const TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}
