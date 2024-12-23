import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TaskController taskController = Get.find<TaskController>();
  AppColors appClrs = AppColors();

  @override
  void initState() {
    super.initState();
    taskController.initialDataAssign();
  }

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
      body: Obx(
        () => taskController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    height: Get.height,
                    width: Get.width,
                    padding: const EdgeInsets.all(10),
                    child: Obx(
                      () => taskController.filterList.isNotEmpty
                          ? ListView.separated(
                              itemCount: taskController.filterList.length,
                              itemBuilder: (context, index) {
                                dynamic data = taskController.filterList[index];
                                return Container(
                                    alignment: Alignment.center,
                                    width: Get.width,
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          data["image"],
                                          height: 40,
                                          width: 40,
                                        ),
                                        UiHelper.horizontalSpaceSmall,
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data["title"],
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              data["description"],
                                              style: const TextStyle(fontSize: 14),
                                            )
                                          ],
                                        )),
                                        UiHelper.horizontalSpaceSmall,
                                        Checkbox(
                                            value: data["status"],
                                            onChanged: (val) {
                                              bool vals = !data["status"];
                                              taskController.updateStatus(data["id"], vals);
                                            }),
                                        GestureDetector(onTap: () {}, child: const Icon(Icons.edit)),
                                        UiHelper.horizontalSpaceSmall,
                                        GestureDetector(
                                            onTap: () {
                                              deleteAlert(data["id"]);
                                            },
                                            child: Icon(Icons.delete, color: appClrs.redclr))
                                      ],
                                    ));
                              },
                              separatorBuilder: (context, index) => Container(
                                height: 2,
                                color: appClrs.greyclr1,
                              ),
                            )
                          : const Center(child: Text("Data Not Found")),
                    ))),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: UiHelper.circleBorderBox(appClrs.greyclr1),
        alignment: Alignment.center,
        child: IconButton(onPressed: () {}, icon: Icon(Icons.add, size: 30, color: appClrs.blackclr)),
      ),
    );
  }

  //// ************ Popup Alert ***********\\\\\
  deleteAlert(int taskId) async {
    await Get.dialog(AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        content: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: SizedBox(
              width: Get.width,
              height: 150,
              child: Column(
                children: [
                  UiHelper.verticalSpaceSmall,
                  const Text(
                    "Do you want to delete this record ?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: Get.width / 4,
                            alignment: Alignment.center,
                            decoration: UiHelper.roundedBorderWithColor(10, Colors.black38),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: const Text("No"),
                          )),
                      UiHelper.horizontalSpaceSmall,
                      GestureDetector(
                          onTap: () {
                            taskController.deleteTask(taskId);
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: Get.width / 4,
                            alignment: Alignment.center,
                            decoration: UiHelper.roundedBorderWithColor(10, appClrs.primaryclr),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: const Text("Yes"),
                          )),
                    ],
                  ),
                  UiHelper.verticalSpaceMedium
                ],
              ),
            ))));
  }
}
