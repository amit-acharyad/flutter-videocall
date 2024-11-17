import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:videocall/auth/authrepo.dart';
import 'package:videocall/auth/login/loginScreen.dart';
import 'package:videocall/videocall/controller/videoCallChecker.dart';

import 'auth/usermodel.dart';
import 'videocall/view/webRTCVideoCallScreen.dart';

class App extends StatelessWidget {
  App({super.key});
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    // final graphql = Get.put(Graphql());

    // graphql.fetchProducts(5);
    // graphql.updateProduct("heyRam");
    // graphql.addUser("jagit", "jag@gmail.com");
    // graphql.removeUser("a665de30-7b5f-11ef-81c2-3e18f8ebc4b3");
    Get.put(AuthenticationRepository());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        backgroundColor: Colors.blue,
        body: Placeholder(),
      ),
      theme: ThemeData.light(),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),

      // Scaffold(
      //   body: Container(
      //     child: Center(
      //       child: InkWell(
      //           onTap: () async {
      //             await graphql.fetchProducts(4);
      //           },
      //           child: Text("data")),
      //       // child: StreamBuilder(
      //       //     stream: graphql.getStream(),
      //       //     builder: (context, snapshot) {
      //       //       if (snapshot.connectionState == ConnectionState.waiting) {
      //       //         return CircularProgressIndicator();
      //       //       }
      //       //       if (!snapshot.hasData) {
      //       //         return Text("No data");
      //       //       }
      //       //       if (snapshot.data!.hasException) {
      //       //         print("snapshot has Exception error");
      //       //         throw "Error ${snapshot.data!.exception.toString()}";
      //       //       }
      //       //       if (snapshot.hasError) {
      //       //         return Text("Has error");
      //       //       }
      //       //       List<dynamic> data = [];
      //       //       data = snapshot.data!.data!["users"];
      //       //       print("data $data");
      //       //       final user = data.map((map) => map["name"]).first;
      //       //       final userId = data.map((map) => map["id"]).first;
      //       //       final verifies =
      //       //           data.map((map) => map['is_email_verified']).first;
      //       //       return ListTile(
      //       //         title: Text("${user} ${verifies}"),
      //       //         subtitle: Text("${userId}"),
      //       //       );
      //       //     }),
      //     ),
      //   ),
      // ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = AuthenticationRepository.instance.currentUser.value;

  @override
  Widget build(BuildContext context) {
    VideoCallChecker.getIncomingVideoCall();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome ${user.name},"),
      ),
      body: Column(
        children: [
          Obx(
            () => VideoCallChecker.currentCall.value.status == 'initiated'
                ? GestureDetector(
                    onTap: () {
                      print(
                          "Going to join room ${VideoCallChecker.currentCall.value.roomId}");
                      Get.to(WebRTCVideoCallScreen(
                        receiverId: "1",
                        roomId: VideoCallChecker.currentCall.value.roomId,
                      ));
                    },
                    child: const SizedBox(
                      height: 80,
                      child: Text('Incoming Call'),
                    ),
                  )
                : SizedBox(),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection("Users").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Text("No data");
                }

                final data = snapshot.data!.docs
                    .map((doc) => UserModel.fromSnapshot(doc))
                    .toList();

                return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return data[index].id ==
                              AuthenticationRepository.instance.user!.uid
                          ? SizedBox()
                          : ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data[index].photoUrl),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(data[index].name),
                              subtitle: Text(data[index].id),
                              onTap: () {
                                print(
                                    "Going to create room for receiver ${data[index].id}");
                                Get.to(WebRTCVideoCallScreen(
                                  receiverId: data[index].id,
                                  roomId: '1',
                                ));
                              },
                            );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 14,
                        ),
                    itemCount: data.length);
              }),
        ],
      ),
    );
  }
}
