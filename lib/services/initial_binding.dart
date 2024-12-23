import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TaskController());
  }
}
