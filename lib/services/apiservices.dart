import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';

TaskController taskController = Get.find<TaskController>();

class Apiservices {
  String email = "testing@gmail.com";
  String password = "Test123@";
  final FlutterSecureStorage pref = const FlutterSecureStorage();

  //// ************ User Login ***********\\\\\
  Future loginFunction(dynamic requestJson) async {
    try {
      if (requestJson['email'] == email && requestJson['password'] == password) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Set User Info
  Future<void> setString(String key, String value) async {
    if (value == "null") {
      value = "";
    }
    await pref.write(key: key, value: value);
  }

// Get User Info
  Future<String> getString(String key) async {
    String getStr = await pref.read(key: key) ?? '';
    if (getStr != '') {
      return getStr;
    }
    return '';
  }
}
