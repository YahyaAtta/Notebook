import 'package:get/get.dart';
import 'package:note_book/controller/device_info_controller.dart';
import 'package:note_book/controller/note_controller.dart';
import 'package:note_book/controller/read_controller.dart';

class NotebookBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => TimerController(), fenix: true);
    Get.lazyPut(() => DeviceInfoController(), fenix: true);
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => ReadController(), fenix: true);
  }
}
