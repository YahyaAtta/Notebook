import 'dart:io';

import 'package:flutter/material.dart';

class NativeDeviceInfo extends StatefulWidget {
  const NativeDeviceInfo({super.key});

  @override
  State<NativeDeviceInfo> createState() => _NativeDeviceInfoState();
}

class _NativeDeviceInfoState extends State<NativeDeviceInfo> {
  String operatingSystemWindows = Platform.operatingSystem;
  String operatingSystemVersion = Platform.operatingSystemVersion;
  int numberOfProcessor = Platform.numberOfProcessors;

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
                          Text("Manufacturer:Samsung"),
                          Text("Model No: Samsung"),
                          Text("Manufacturer: Samsung"),
                          Text("Android Version:"),
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
