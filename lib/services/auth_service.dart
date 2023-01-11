import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/student_model/student_model.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class AuthService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthService(this.firebaseAuth, this.firebaseFirestore);

  Stream<User?> get userCurrentState => firebaseAuth.authStateChanges();

  void signInUser(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      log("successful login");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else
        log(e.message.toString());
    }
  }

  Future<StudentModel?> fetchStudentDetails(String email) async {
    StudentModel? studentModel;

    firebaseFirestore
        .collection("Students")
        .where("email", isEqualTo: email)
        .get()
        .then(
      (res) {
        log(res.docs.toString());
        var a = res.docs.map((e) {
          return e.data()["email"];
        });

        log(a.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );

    return studentModel;
  }
}
