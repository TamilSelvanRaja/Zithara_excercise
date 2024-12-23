import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/app_colors.dart';

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  TaskController taskController = Get.find<TaskController>();
  AppColors appClrs = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          GestureDetector(
            onTap: () {
              taskController.isDarkMode.value = !taskController.isDarkMode.value;
            },
            child: const CircleAvatar(
              radius: 25,
              child: Icon(Icons.dark_mode),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'List',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
