import 'package:flutter/material.dart';

class IntroComponent extends StatelessWidget {
  final String title;
  final String desc;
  final String imagePath;
  const IntroComponent(
      {super.key,
      required this.title,
      required this.desc,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 30,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.asset(
              imagePath,
              height: 260,
            )),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
