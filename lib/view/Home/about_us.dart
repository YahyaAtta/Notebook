import 'package:flutter/material.dart';
import 'package:note_book/controller/Logic/note_logic.dart';
import 'package:note_book/main.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beginner Programmer"),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'Device Info',
              onPressed: () {
                AppLogic.goDeviceInfoPage(context);
              },
              icon: Icon(
                Icons.info_rounded,
                size: 30,
              )),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40, left: 4, right: 4, bottom: 4),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/OIU.png',
                        height: 70,
                      ),
                    ),
                    const Column(
                      children: [
                        Text("Omdurman Islamic University\n",
                            style: TextStyle(fontSize: 14.75)),
                        Text(
                            "Faculty Of Computer Science\nAnd Information Technology",
                            style: TextStyle(fontSize: 14.75)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/OIU.FCSIT.png',
                        height: 70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.asset(
                      notebookLogo,
                      height: 200,
                      width: 200,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text('Notebook Version 1.2',
                    style: TextStyle(fontSize: 20)),
                const Text(
                  "Developed By Yahya Atta\nFourth Year\nComputer Science(CS)\nGithub:YahyaAtta",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
