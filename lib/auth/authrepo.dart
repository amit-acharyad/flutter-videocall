import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:videocall/auth/login/loginScreen.dart';
import 'package:videocall/auth/usermodel.dart';
import 'package:videocall/videocall/model/videocallModel.dart';
import 'package:videocall/videocall/view/callEndScreen.dart';

import '../app.dart';
import 'signup/signupcontroller.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  User? get user => FirebaseAuth.instance.currentUser;
  Rx<UserModel> currentUser = UserModel.empty().obs;
  final storage = GetStorage();
  final SignupController signupController = Get.put(SignupController());
  
  @override
  void onReady() async {
    if (user != null) {
      final appUser = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid)
          .get();
      currentUser.value = UserModel.fromSnapshot(appUser);
      storage.read('isLoggedIn') == true
          ? Get.to(HomeScreen())
          : Get.to(SignInScreen());
    } else {
      Get.to(SignInScreen());
    }
  }
  

  Future<void> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      storage.write('isLoggedIn', true);
      final cUser = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .get();
      final mUser = UserModel.fromSnapshot(cUser);
      currentUser.value = mUser;

      Get.to(HomeScreen());
      print("Login Successful");
    } catch (e) {
      throw "Login Error${e.toString()}";
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("User created successfully");
      final user = UserModel(
          id: userCredential.user!.uid,
          name: signupController.nameController.text.trim(),
          photoUrl: "");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      Get.to(SignInScreen());
    } on FirebaseException catch (e) {
      throw "Firebase Exception in signUp ${e.toString()}";
    } catch (e) {
      throw "SignUp with failed ${e.toString()}";
    }
  }
}
