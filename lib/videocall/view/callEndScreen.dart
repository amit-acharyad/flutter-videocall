import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app.dart';
import '../../auth/authrepo.dart';

class CallEndScreen extends StatelessWidget {
  const CallEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Get.to(HomeScreen());
                  },
                  icon: Icon(Icons.cancel_outlined)),
            ),
            SizedBox(height: 150,),
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(AuthenticationRepository
                  .instance.currentUser.value.photoUrl),
            ),
            SizedBox(height: 24,),
            Text("Call Ended."),
            Spacer()
          ],
        ),
      ),
    ));
  }
}
