import 'package:get/get.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';

class TaskController extends GetxController {
  List dummytaskData = [
    {"id": 0, "due_date": "25-06-2025", "title": "Image Upload Task", "description": "Upload for user photo", "status": false, "image": "assets/task1.png"},
    {"id": 1, "due_date": "02-01-2025", "title": "Name Change", "description": "Consumer name change reports", "status": false, "image": "assets/task2.png"},
    {"id": 2, "due_date": "23-03-2025", "title": "Api Integration", "description": "Rest API's Development and integration", "status": false, "image": "assets/task3.png"},
  ];
  RxBool isDarkMode = false.obs;
  RxBool isLoading = false.obs;
  RxList taskList = [].obs;
  RxList filterList = [].obs;
  Future initialDataAssign() async {
    isLoading.value = true;
    taskList.value = dummytaskData;
    Future.delayed((const Duration(seconds: 2)), () {
      isLoading.value = false;
    });
  }

  Future addNewTask(dynamic requestData) async {
    isLoading.value = true;
    requestData['id'] = taskList.length;
    requestData['status'] = false;
    taskList.add(requestData);
    Future.delayed((const Duration(seconds: 2)), () {
      isLoading.value = false;
      Get.back();
      UiHelper().commonsnack("Success", "New task has been successfully saved.");
    });
  }

  Future editTask(dynamic requestData) async {
    isLoading.value = true;
    taskList.value = taskList.map((data) {
      if (data['id'] == requestData["id"]) {
        requestData.forEach((key, value) {
          data[key] = requestData[key];
        });
      }
      return data;
    }).toList();
    Future.delayed((const Duration(seconds: 2)), () {
      isLoading.value = false;
      Get.back();
      UiHelper().commonsnack("Success", "Task has been successfully updated.");
    });
  }

  Future updateStatus(int id, bool value) async {
    taskList.value = taskList.map((data) {
      if (data['id'] == id) {
        data['status'] = value;
      }
      return data;
    }).toList();
  }

  Future deleteTask(int id) async {
    taskList.value = taskList.where((e) => e['id'] != id).toList();
  }

  Future fiteringData(String name, String datestr, bool isSorting) async {
    if (isSorting) {
      taskList.sort((a, b) => a['title'].toString().compareTo(b['title']));
    }
    if (datestr.isNotEmpty) {
    } else {
      filterList.value = taskList.where((e) => e['title'].toString().toLowerCase().contains(name.toString().toLowerCase())).toList();
    }
  }
}
