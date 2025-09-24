import 'package:flutter/material.dart';
import 'package:clock/clock.dart';
import 'dart:async';

class TimeController extends ChangeNotifier {
  Object? hour;
  Object? minute;
  Object? second;
  Clock clock = const Clock();
  Object? get getHour {
    return hour;
  }

  Object? get getMinute {
    return minute;
  }

  Object? get getSecond {
    return second;
  }

  void getRealTime() {
    if (hour == null && minute == null && second == null) {
      hour = "00";
      minute = "00";
      second = "00";
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      hour = clock.now().hour < 10 ? "0${clock.now().hour}" : clock.now().hour;
      minute = clock.now().minute < 10
          ? "0${clock.now().minute}"
          : clock.now().minute;
      second = clock.now().second < 10
          ? "0${clock.now().second}"
          : clock.now().second;
      notifyListeners();
    });
  }
}
