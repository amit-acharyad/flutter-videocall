import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:videocall/app.dart';
import 'package:videocall/firebase_options.dart';

import 'auth/authrepo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetStorage().writeIfNull('isLoggedIn', false);
  runApp(App());
}
