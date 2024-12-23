import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:intl/intl.dart';

class AddEditScreen extends StatefulWidget {
  const AddEditScreen({super.key, required this.isNew, this.initialData});
  final bool isNew;
  final dynamic initialData;
  @override
  State<AddEditScreen> createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  AppColors appClrs = AppColors();
  TaskController taskController = Get.find<TaskController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String title = "";
  String desc = "";
  String due = "";
  String localPath = "";
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      title = widget.initialData['title'];
      desc = widget.initialData['description'];
      due = widget.initialData['due_date'];
      localPath = widget.initialData['image'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? "Add Task" : "Edit Task"),
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
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: Get.height,
            width: Get.width,
            alignment: Alignment.center,
            decoration: UiHelper.roundedBorderWithimage(0, "assets/bg1.jpg", imgopacity: 0.7),
            padding: const EdgeInsets.all(16),
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    UiHelper.verticalSpaceLarge,
                    GestureDetector(
                      onTap: () {
                        showFilePickerSheet();
                      },
                      child: Container(
                        child: localPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(36.0),
                                child: localPath.contains("assets/") ? Image.asset(localPath, width: 72, height: 72, fit: BoxFit.cover) : Image.file(File(localPath), width: 72, height: 72, fit: BoxFit.cover),
                              )
                            : Container(
                                width: 72,
                                height: 72,
                                decoration: UiHelper.circleBorderBox(appClrs.whiteclr),
                                child: Icon(Icons.camera_alt, size: 30, color: appClrs.primaryclr),
                              ),
                      ),
                    ),
                    UiHelper.verticalSpaceMedium,
                    inputFormControl("title", "Title", Icons.title_outlined, title),
                    UiHelper.verticalSpaceMedium,
                    datepickerFormControl("due_date", "Due Date", Icons.date_range, due),
                    UiHelper.verticalSpaceMedium,
                    inputFormControl("description", "Description", Icons.description_outlined, desc),
                    UiHelper.verticalSpaceMedium,
                    Obx(() => taskController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                                postParams['due_date'] = due;
                                postParams['image'] = localPath;
                                if (widget.isNew) {
                                  taskController.addNewTask(postParams);
                                } else {
                                  postParams['id'] = widget.initialData['id'];
                                  postParams['status'] = widget.initialData['status'];
                                  taskController.editTask(postParams);
                                }
                              }
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: UiHelper.roundedBorderWithColor(10, appClrs.primaryclr),
                              child: Text(
                                widget.isNew ? "Submit" : "Update",
                                style: TextStyle(color: appClrs.whiteclr, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ************* Input Field Widget ********************* \\
  Widget inputFormControl(String nameField, String hintText, IconData icon, String initval) {
    return FormBuilderTextField(
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: appClrs.primaryclr),
        name: nameField,
        autocorrect: false,
        maxLines: nameField == "description" ? 5 : 1,
        maxLength: nameField == "description" ? 100 : 40,
        initialValue: initval,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 25,
            color: appClrs.primaryclr,
          ),
          labelText: hintText,
          labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: appClrs.blackclr),
          filled: true,
          fillColor: appClrs.whiteclr,
          enabledBorder: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
          focusedBorder: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
          focusedErrorBorder: UiHelper.getInputBorder(1, borderColor: appClrs.redclr),
          errorBorder: UiHelper.getInputBorder(1, borderColor: appClrs.redclr),
          errorStyle: const TextStyle(fontSize: 10),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        validator: ((value) {
          if (nameField == "title") {
            if (value == "" || value == null) {
              return "$hintText is required";
            }
          }

          return null;
        }));
  }

  // ************* Input Field Widget ********************* \\
  Widget datepickerFormControl(String nameField, String hintText, IconData icon, String initval) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    return FormBuilderDateTimePicker(
      name: nameField,
      initialValue: initval.isNotEmpty ? format.parse(initval) : null,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: appClrs.primaryclr),
      inputType: InputType.date,
      format: DateFormat('dd-MM-yyyy'),
      timePickerInitialEntryMode: TimePickerEntryMode.dial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      firstDate: DateTime.now(),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 25,
          color: appClrs.primaryclr,
        ),
        labelText: hintText,
        labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: appClrs.blackclr),
        filled: true,
        fillColor: appClrs.whiteclr,
        enabledBorder: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
        focusedBorder: UiHelper.getInputBorder(1, borderColor: appClrs.whiteclr),
        focusedErrorBorder: UiHelper.getInputBorder(1, borderColor: appClrs.redclr),
        errorBorder: UiHelper.getInputBorder(1, borderColor: appClrs.redclr),
        errorStyle: const TextStyle(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      validator: (value) {
        if (value == null) {
          return "$hintText ${'isEmpty'.tr}";
        }
        return null;
      },
      onChanged: (value) {
        DateTime inputDate = DateTime.parse(value.toString());
        due = format.format(inputDate);
        setState(() {});
      },
    );
  }

  void showFilePickerSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: ListView(
              children: [
                UiHelper.verticalSpaceSmall,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Select a type')],
                ),
                UiHelper.verticalSpaceSmall,
                UiHelper.verticalSpaceTiny,
                ListTile(
                  onTap: () {
                    Get.back();
                    getImage(FileType.video);
                  },
                  visualDensity: VisualDensity.compact,
                  title: const Text('Camera'),
                ),
                UiHelper.verticalSpaceTiny,
                ListTile(
                  onTap: () {
                    Get.back();
                    getImage(FileType.image);
                  },
                  visualDensity: VisualDensity.compact,
                  title: const Text('Photo Library'),
                ),
              ],
            ),
          );
        });
  }

  Future getImage(FileType fileType) async {
    final pickedFile = await picker.getImage(source: fileType == FileType.video ? ImageSource.camera : ImageSource.gallery, maxWidth: 240);
    if (pickedFile != null) {
      setState(() {
        localPath = pickedFile.path;
      });
    }
  }
}
