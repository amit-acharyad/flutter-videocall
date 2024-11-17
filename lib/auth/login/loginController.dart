import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authrepo.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordControleler = TextEditingController();

  Future<void> login() async {
    try {
      await AuthenticationRepository.instance
          .signIn(emailController.text.trim(), passwordControleler.text.trim());
      print("Login Success");
    } catch (e) {
      throw "Error logging in${e.toString()}";
    }
  }
}
