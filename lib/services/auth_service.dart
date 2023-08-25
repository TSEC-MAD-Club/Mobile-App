import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'dart:io';

import 'package:go_router/go_router.dart';

import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/custom_text_with_divider.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_screen_appbar.dart';
import 'package:tsec_app/screens/profile_screen/widgets/profile_text_field.dart';
import 'package:tsec_app/widgets/custom_scaffold.dart';
import '../../utils/image_pick.dart';
import '../../utils/themes.dart';
import 'package:intl/intl.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

class AuthService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  AuthService(this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage);
  CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('Students ');

  Stream<User?> get userCurrentState => firebaseAuth.authStateChanges();

  User? get user => firebaseAuth.currentUser;

  Future<UserCredential?> signInUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      } else
        showSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future resetPassword(String email, BuildContext context) async {
    // User user = firebaseAuth.currentUser!;
    // await user.updatePassword(password);

    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  void updatePassword(String password, BuildContext context) async {
    User user = firebaseAuth.currentUser!;
    await user.updatePassword(password);
  }

  Future<StudentModel> updateUserDetails(StudentModel student) async {
    DocumentReference studentDoc = studentCollection.doc(user!.uid);
    await studentDoc.update(student.toJson());
    final updatedUserData = await studentDoc.get();

    var userMap = updatedUserData.data() as Map<String, dynamic>;
    StudentModel updatedStudentData = StudentModel.fromJson(userMap);
    debugPrint("updated student data in auth service is $updatedStudentData");
    return updatedStudentData;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Future<String> updateProfilePic(Uint8List image) async {
    // File file = await File.fromRawPath(image).writeAsBytes(image);
    Uint8List imageInUnit8List = image;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    debugPrint(user!.uid.toString());
    var imageRef = await firebaseStorage
        .ref()
        .child("Images")
        .child("/${user?.uid}")
        .putFile(file);
    var downloadURL = await imageRef.ref.getDownloadURL();
    debugPrint("download url in service is $downloadURL");
    // https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F82K8zTy8bhaW8auWxn2oK3ql6n03?alt=media&token=cdd8d8f3-dd4f-43b0-979a-a2949d5266f6
    return downloadURL;
  }

  Future<StudentModel?> fetchStudentDetails(
      User? user, BuildContext context) async {
    StudentModel? studentModel;

    try {
      final studentSnap =
          await firebaseFirestore.collection("Students ").doc(user!.uid).get();

      final studentDoc = studentSnap.data();
      if (studentDoc != null) {
        studentModel = StudentModel.fromJson(studentDoc);
      } else {
        studentModel = null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(
          context, e.stackTrace.toString() + " " + e.message.toString());
    }

    return studentModel;
  }

  Future signout() async {
    await firebaseAuth.signOut();
  }
}
