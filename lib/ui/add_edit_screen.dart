import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';

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
                    addInputFormControl("title", "Title", Icons.title_outlined),
                    UiHelper.verticalSpaceMedium,
                    addInputFormControl("description", "Description", Icons.description_outlined),
                    UiHelper.verticalSpaceMedium,
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
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
                    ),
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
  Widget addInputFormControl(String nameField, String hintText, IconData icon) {
    return Column(
      children: [
        FormBuilderTextField(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: appClrs.primaryclr),
            name: nameField,
            autocorrect: false,
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
            })),
      ],
    );
  }
}
