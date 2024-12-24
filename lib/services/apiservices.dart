import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';

TaskController taskController = Get.find<TaskController>();

class Apiservices {
  final FlutterSecureStorage pref = const FlutterSecureStorage();

  //// ************ User Login ***********\\\\\
  Future loginFunction1(dynamic requestJson) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: requestJson['email'],
        password: requestJson['password'],
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
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
