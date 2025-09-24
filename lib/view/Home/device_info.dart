import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/note_logic.dart';

class NativeDeviceInfo extends StatefulWidget {
  const NativeDeviceInfo({super.key});

  @override
  State<NativeDeviceInfo> createState() => _NativeDeviceInfoState();
}

class _NativeDeviceInfoState extends State<NativeDeviceInfo> {
  String operatingSystemWindows = Platform.operatingSystem;
  String operatingSystemVersion = Platform.operatingSystemVersion;
  int numberOfProcessor = Platform.numberOfProcessors;
  Map<String, String>? hardware;
  @override
  void initState() {
    hardware = AppLogic().getDeviceFromNative();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Platform.isAndroid
                ? [
                    Icon(
                      Icons.phone_android,
                      size: 33,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Native Device Info"),
                  ]
                : [
                    Icon(
                      Icons.window_sharp,
                      size: 33,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Native Device Info"),
                  ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Column(
                  children: Platform.isAndroid
                      ? [
                          Text("Manufacturer:${hardware!['Manufacturer']}"),
                          Text("Model No: ${hardware!['Model No']}"),
                          Text("Board: ${hardware!['Board']}"),
                          Text("Android Version: ${hardware!['Version']}"),
                        ]
                      : [
                          Text("Operating System: $operatingSystemWindows"),
                          Text(operatingSystemVersion),
                          Text("Number Of Processors: $numberOfProcessor")
                        ],
                ),
                leading: Platform.isAndroid
                    ? Icon(
                        Icons.android_rounded,
                        size: 40,
                      )
                    : Icon(
                        Icons.window_sharp,
                        size: 40,
                      ),
                trailing: Icon(
                  Icons.verified,
                  size: 34,
                  color: Colors.green,
                ),
                contentPadding: EdgeInsets.all(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
