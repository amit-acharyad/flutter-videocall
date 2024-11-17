import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authrepo.dart';

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Future<void> signUp() async {
    await AuthenticationRepository.instance
        .signUp(emailController.text.trim(), passwordController.text.trim());
  }
}
