import 'dart:io';

import 'package:get/get.dart';
import 'package:jni/jni.dart';

import 'bindings/hardware_utils_bindings.dart';

class DeviceInfoController extends GetxController {
  bool isAndroidPlatform = Platform.isAndroid;
  String operatingSystemWindows = Platform.operatingSystem;
  String operatingSystemVersion = Platform.operatingSystemVersion;
  int numberOfProcessor = Platform.numberOfProcessors;
  Map<String, String>? hardware;
  Map<String, String> getDeviceInfoFromNative() {
    if (Platform.isAndroid) {
      final dartMap = <String, String>{};
      final jMap = KotlinHardwareUtils().getHardwareKotlinUtils();
      final JSet<JString> keys = jMap.keys;
      for (JString jkey in keys) {
        final String key = jkey.toDartString();
        final JString? jVal = jMap[jkey];
        dynamic value;
        if (jVal == null) {
          value = null;
        } else {
          value = jVal.toDartString();
        }

        dartMap[key] = value;
      }
      return dartMap;
    }
    return {};
  }

  @override
  void onInit() {
    hardware = getDeviceInfoFromNative();
    update();
    super.onInit();
  }
}
