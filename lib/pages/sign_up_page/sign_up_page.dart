import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/core/exceptions/factory_map_exception.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/services/snackbar_service.dart';
import 'package:foodie/pages/home_page/home_page.dart';
import 'package:foodie/pages/login_page/models/user_info.dart';
import 'package:foodie/pages/sign_up_page/models/sign_up_form_data.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Expanded(
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 35.0),
                    child: const Text(
                      "Create an account",
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordConfirmationController,
                      decoration: const InputDecoration(
                        hintText: "Password Confirmation",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: signUp,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Sign up",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  String? validateFields() {
    if (usernameController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      return 'Please fill all fields to continue';
    }
    if (passwordConfirmationController.text != passwordController.text) {
      return 'Password and Password Confirmation Fields don\'t match';
    }
    if (!phoneNumberController.text.isNumericOnly) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> signUp() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    SignUpFormData formData = SignUpFormData(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      password: passwordController.text,
      phoneNumber: phoneNumberController.text,
    );
    try {
      String result = await HttpService.rawPost(
        endPoint: 'users/signup/',
        body: formData.toMap(),
      );
      var decodedResult = jsonDecode(result);
      UserInfo info = UserInfo.fromMap(decodedResult);
      await SharedPreferencesService.instance.setInt(
        key: 'userId',
        value: info.id,
      );
      // ignore: use_build_context_synchronously
      NavigationService.pushAndPopAll(
        context,
        const HomePage(),
      );
    } on FactoryMapException catch (e) {
      if (e.map.keys.contains('username')) {
        SnackBarService.showErrorSnackbar(
          'This username is already bound to another account',
        );
        return;
      }
      SnackBarService.showErrorSnackbar(
        'This phone number is already bound to another account',
      );
    } catch (e) {
      SnackBarService.showErrorSnackbar('Error Occurred');
    }
  }
}
