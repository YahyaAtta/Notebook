import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jni/jni.dart';
import 'package:note_book/controller/bindings/hardware_utils_bindings.dart';
import 'package:note_book/model/data_static/assets_model.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("about".tr),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'Device Info',
              onPressed: () {
                Get.toNamed("/device");
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
                        AssetsImageModel.oiulogo,
                        height: 70,
                      ),
                    ),
                    Column(
                      children: [
                        Text("${"oiu".tr}\n".tr,
                            style: TextStyle(
                                fontSize: 14.75, fontWeight: FontWeight.w600)),
                        Text("fcsit".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.75, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AssetsImageModel.oiufcsit,
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
                      AssetsImageModel.notebook,
                      height: 200,
                      width: 200,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text('ver'.tr, style: TextStyle(fontSize: 20)),
                Text(
                  "${"dev".tr}\n${"year".tr}\n${"dep".tr}\n${"git".tr}",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () {
                      KotlinHardwareUtils().openLink(
                          JObject.fromReference(Jni.getCurrentActivity()),
                          "http://www.github.com/YahyaAtta".toJString());
                    },
                    child: Text("My Github",
                        style:
                            TextStyle(decoration: TextDecoration.underline))),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
