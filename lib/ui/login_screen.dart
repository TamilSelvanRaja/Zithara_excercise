import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/resources/app_colors.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:zithara_excersize/services/apiservices.dart';
import 'package:zithara_excersize/services/router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AppColors appClrs = AppColors();
  bool isVisiblityOn = true;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    decoration: UiHelper.roundedBorderWithColor(14, appClrs.primaryclr),
                    child: Text(
                      "Z",
                      style: TextStyle(fontWeight: FontWeight.w900, color: appClrs.whiteclr, fontSize: 70),
                    ),
                  ),
                  UiHelper.verticalSpaceMedium,
                  addInputFormControl("email", "Email"),
                  UiHelper.verticalSpaceMedium,
                  addInputFormControl("password", "Password", isShowSuffixIcon: true),
                  UiHelper.verticalSpaceMedium,
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                        bool res = await Apiservices().loginFunction1(postParams);
                        if (res) {
                          Get.offNamedUntil(RoutePaths.home, (e) => false);
                          UiHelper().commonsnack("Success", "Login Success");
                          Apiservices().setString("islogin", "true");
                        } else {
                          Apiservices().setString("islogin", "false");
                          UiHelper().commonsnack("Failed", "Email id or password is does't match");
                        }
                      }
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: UiHelper.roundedBorderWithColor(10, appClrs.primaryclr),
                      child: Text(
                        "Sign in",
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
    );
  }

  // ************* Input Field Widget ********************* \\
  Widget addInputFormControl(String nameField, String hintText, {bool isShowSuffixIcon = false}) {
    return Column(
      children: [
        FormBuilderTextField(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: appClrs.primaryclr),
            obscureText: nameField == "password" && isVisiblityOn,
            name: nameField,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {},
            decoration: InputDecoration(
              suffixIcon: isShowSuffixIcon
                  ? GestureDetector(
                      onTap: () {
                        isVisiblityOn = !isVisiblityOn;
                        setState(() {});
                      },
                      child: Icon(
                        isVisiblityOn ? Icons.visibility : Icons.visibility_off,
                        size: 25,
                        color: appClrs.primaryclr,
                      ))
                  : null,
              prefixIcon: Icon(
                nameField == "password" ? Icons.lock : Icons.person,
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
              if (value == "" || value == null) {
                return "$hintText is required";
              } else if (nameField == "email") {
                if (!isEmailValid(value)) {
                  return "$hintText is Invalid";
                }
              }
              return null;
            })),
      ],
    );
  }

  bool isEmailValid(value) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
  }
}
