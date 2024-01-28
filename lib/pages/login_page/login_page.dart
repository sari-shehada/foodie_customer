// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie/core/services/http_service.dart';
import 'package:foodie/core/services/navigation_service.dart';
import 'package:foodie/core/services/shared_prefs_service.dart';
import 'package:foodie/core/services/snackbar_service.dart';
import 'package:foodie/pages/home_page/home_page.dart';
import 'package:foodie/pages/login_page/models/login_form_data.dart';
import 'package:foodie/pages/login_page/models/user_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
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
                      "Log in to your account",
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
                      controller: userNameController,
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
                  MaterialButton(
                    onPressed: login,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        "log in",
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
                  "Don't have an account?",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Register()));
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
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please fill all fields to continue';
    }
    return null;
  }

  Future<void> login() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    LoginFormData formData = LoginFormData(
      username: userNameController.text,
      password: passwordController.text,
    );
    try {
      String result = await HttpService.rawPost(
        endPoint: 'users/login/',
        body: formData.toMap(),
      );
      var decodedResult = jsonDecode(result);

      if (decodedResult == false) {
        throw Exception();
      }
      UserInfo info = UserInfo.fromMap(decodedResult);
      await SharedPreferencesService.instance.setInt(
        key: 'userId',
        value: info.id,
      );
      NavigationService.pushAndPopAll(
        context,
        const HomePage(),
      );
    } catch (e) {
      SnackBarService.showErrorSnackbar('Invalid Login Credentials!');
    }
  }
}
