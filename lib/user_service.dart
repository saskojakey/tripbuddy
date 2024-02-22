import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String uid, String email, String username) async {
    return usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    DocumentSnapshot snapshot = await usersCollection.doc(uid).get();
    return snapshot.data() as Map<String, dynamic>?;
  }
}
