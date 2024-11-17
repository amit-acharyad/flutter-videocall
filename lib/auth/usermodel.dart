import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;

  late final String photoUrl;
  UserModel({required this.id, required this.name, required this.photoUrl});
  static UserModel empty() => UserModel(id: '', name: '', photoUrl: '');
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      return UserModel(
          id: data?['id'], name: data?['name'], photoUrl: data?['photoUrl']);
    } else {
      return UserModel.empty();
    }
  }
  factory UserModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentQuerySnapshot) {
    if (documentQuerySnapshot.exists) {
      final data = documentQuerySnapshot.data();
      return UserModel(
          id: data['id'], name: data['name'], photoUrl: data['photoUrl']);
    } else {
      return UserModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'photoUrl': photoUrl};
  }
}
