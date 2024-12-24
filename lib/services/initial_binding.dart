import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/services/apiservices.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TaskController());
    Get.put(Apiservices());
  }
}
