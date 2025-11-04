import 'dart:io';
import 'package:get/get.dart';
import 'bindings/hardware_utils_bindings.dart' as android;

class DeviceInfoController extends GetxController {
  bool isAndroidPlatform = Platform.isAndroid;
  String operatingSystemWindows = Platform.operatingSystem;
  String operatingSystemVersion = Platform.operatingSystemVersion;
  int numberOfProcessor = Platform.numberOfProcessors;
  Map<String, dynamic>? hardware;
  Map<String, dynamic> getNativeDeviceInfo() {
    Map<String, dynamic> deviceInfo = <String, dynamic>{};
    deviceInfo['Manufacturer'] = android.Build.MANUFACTURER!.toDartString();
    deviceInfo['Model'] = android.Build.MODEL!.toDartString();
    deviceInfo['Board'] = android.Build.BOARD!.toDartString();
    deviceInfo['Version'] = android.Build$VERSION.RELEASE!.toDartString();
    deviceInfo['Codename'] = android.Build$VERSION.CODENAME!.toDartString();
    deviceInfo['Sdkint'] = android.Build$VERSION.SDK_INT;
    return deviceInfo;
  }

  @override
  void onInit() {
    hardware = getNativeDeviceInfo();
    update();
    super.onInit();
  }
}
