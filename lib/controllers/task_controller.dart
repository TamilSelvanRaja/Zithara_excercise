import 'package:get/get.dart';

class TaskController extends GetxController {
  List dummytaskData = [
    {"id": 0, "title": "Image Upload Task", "description": "Upload for user photo", "status": false, "image": "assets/task1.png"},
    {"id": 1, "title": "Name Change", "description": "Consumer name change reports", "status": false, "image": "assets/task2.png"},
    {"id": 2, "title": "Api Integration", "description": "Rest API's Development and integration", "status": false, "image": "assets/task3.png"},
  ];
  RxBool isDarkMode = false.obs;
  RxBool isLoading = false.obs;
  RxList taskList = [].obs;
  RxList filterList = [].obs;

  Future initialDataAssign() async {
    isLoading.value = true;
    taskList.value = dummytaskData;
    filterList.value = dummytaskData;
    Future.delayed((const Duration(seconds: 2)), () {
      isLoading.value = false;
    });
  }

  Future addNewTask(dynamic value) async {}

  Future updateStatus(int id, bool value) async {
    filterList.value = taskList.map((data) {
      if (data['id'] == id) {
        data['status'] = value;
      }
      return data;
    }).toList();
  }

  Future deleteTask(int id) async {
    filterList.value = taskList.where((e) => e['id'] != id).toList();
    taskList.value = filterList;
  }
}
