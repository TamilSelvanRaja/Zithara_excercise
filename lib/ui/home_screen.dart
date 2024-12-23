import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:zithara_excersize/ui/add_edit_screen.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TaskController taskController = Get.find<TaskController>();
  AppColors appClrs = AppColors();
  bool isSorting = false;
  String searchkey = "";
  String datestr = "";

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
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(flex: 3, child: inputFormControl()),
                          UiHelper.horizontalSpaceSmall,
                          Expanded(flex: 2, child: datepickerFormControl()),
                          UiHelper.horizontalSpaceSmall,
                          GestureDetector(
                              onTap: () {
                                isSorting = true;
                                setState(() {});
                              },
                              child: const Icon(Icons.swap_vert)),
                          // UiHelper.horizontalSpaceSmall,
                          // GestureDetector(
                          //     onTap: () {
                          //       searchkey = "";
                          //       datestr = "";
                          //       isSorting = false;
                          //       setState(() {});
                          //     },
                          //     child: const Icon(Icons.search_off)),
                        ]),
                        Expanded(
                          child: Obx(() {
                            taskController.fiteringData(searchkey, datestr, isSorting);
                            return taskController.filterList.isNotEmpty
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
                                              data["image"].toString().isNotEmpty
                                                  ? data["image"].contains("assets/")
                                                      ? Image.asset(
                                                          data["image"],
                                                          height: 40,
                                                          width: 40,
                                                        )
                                                      : Image.file(File(data["image"]), width: 40, height: 40, fit: BoxFit.cover)
                                                  : Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: UiHelper.circleBorderBox(appClrs.whiteclr),
                                                      child: Icon(Icons.camera_alt, size: 30, color: appClrs.primaryclr),
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
                                                    data["due_date"],
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                                              GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => AddEditScreen(isNew: false, initialData: data));
                                                  },
                                                  child: const Icon(Icons.edit)),
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
                                : const Center(child: Text("Data Not Found"));
                          }),
                        ),
                      ],
                    ))),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: UiHelper.circleBorderBox(appClrs.greyclr1),
        alignment: Alignment.center,
        child: IconButton(
            onPressed: () {
              Get.to(() => const AddEditScreen(isNew: true));
            },
            icon: Icon(Icons.add, size: 30, color: appClrs.blackclr)),
      ),
    );
  }

  //// ************ Popup Alert ***********\\\\\
  deleteAlert(int taskId) async {
    await Get.dialog(AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        // ignore: deprecated_member_use
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

  // ************* Input Field Widget ********************* \\
  Widget inputFormControl() {
    return FormBuilderTextField(
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: appClrs.primaryclr),
      name: "search",
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        searchkey = value.toString();
        setState(() {});
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: appClrs.primaryclr,
        ),
        labelText: "Search task name..",
        labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: appClrs.blackclr),
        filled: true,
        fillColor: appClrs.whiteclr,
        border: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
    );
  }

  // ************* Input Field Widget ********************* \\
  Widget datepickerFormControl() {
    DateFormat format = DateFormat('dd-MM-yyyy');
    return FormBuilderDateTimePicker(
      name: "date",
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: appClrs.primaryclr),
      inputType: InputType.date,
      format: DateFormat('dd-MM-yyyy'),
      timePickerInitialEntryMode: TimePickerEntryMode.dial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      firstDate: DateTime.now(),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.date_range,
          size: 20,
          color: appClrs.primaryclr,
        ),
        labelText: "Date",
        labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: appClrs.blackclr),
        filled: true,
        fillColor: appClrs.whiteclr,
        border: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      onChanged: (value) {
        if (value != null) {
          DateTime inputDate = DateTime.parse(value.toString());
          datestr = format.format(inputDate);
          setState(() {});
        }
      },
    );
  }
}
