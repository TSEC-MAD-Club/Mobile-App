import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsec_app/models/faculty_model/faculty_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/utils/custom_snackbar.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  CollectionReference<Map<String, dynamic>> studentCollection =
      FirebaseFirestore.instance.collection('Students ');
  CollectionReference<Map<String, dynamic>> professorsCollection =
      FirebaseFirestore.instance.collection('Professors');

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

  Future<StudentModel> updateStudentDetails(StudentModel student) async {
    DocumentReference studentDoc = studentCollection.doc(user!.uid);
    await studentDoc.update(student.toJson());
    final updatedUserData = await studentDoc.get();

    var userMap = updatedUserData.data() as Map<String, dynamic>;
    StudentModel updatedStudentData = StudentModel.fromJson(userMap);
    // debugPrint("updated student data in auth service is $updatedStudentData");
    return updatedStudentData;
  }

  Future<FacultyModel> updateFacultyDetails(FacultyModel prof) async {
    DocumentReference profDoc = professorsCollection.doc(user!.uid);
    await profDoc.update(prof.toJson());
    final updatedUserData = await profDoc.get();
    var userMap = updatedUserData.data() as Map<String, dynamic>;
    FacultyModel updatedFacultyData = FacultyModel.fromJson(userMap);
    return updatedFacultyData;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Future<String> updateProfilePic(Uint8List image, UserModel userModel) async {
    // File file = await File.fromRawPath(image).writeAsBytes(image);
    Uint8List imageInUnit8List = image;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    // debugPrint(user!.uid.toString());
    // var imageRef = await firebaseStorage
    //     .ref()
    //     .child("Images")
    //     .child("/${user?.uid}")
    //     .putFile(file);
    var imageRef =
        await firebaseStorage.ref().child("profile/${user?.uid}").putFile(file);
    var downloadURL = await imageRef.ref.getDownloadURL();
    if (userModel.isStudent) {
      StudentModel student = userModel.studentModel!;
      student.image = downloadURL;
      updateStudentDetails(student);
    } else {
      FacultyModel prof = userModel.facultyModel!;
      prof.image = downloadURL;
      updateFacultyDetails(prof);
    }
    // debugPrint("download url in service is $downloadURL");
    // https://firebasestorage.googleapis.com/v0/b/tsec-app.appspot.com/o/Images%2F82K8zTy8bhaW8auWxn2oK3ql6n03?alt=media&token=cdd8d8f3-dd4f-43b0-979a-a2949d5266f6
    return downloadURL;
  }

  Future<UserModel?> fetchUserDetails(User? user, BuildContext context) async {
    UserModel? userModel;

    try {
      final studentSnap = await studentCollection.doc(user!.uid).get();
      final studentDoc = studentSnap.data();

      if (studentDoc != null) {
        userModel = UserModel(
            isStudent: true, studentModel: StudentModel.fromJson(studentDoc));
      } else {
        final profSnap = await professorsCollection.doc(user.uid).get();
        final profDoc = profSnap.data();
        userModel = profDoc != null
            ? UserModel(
                isStudent: false, facultyModel: FacultyModel.fromJson(profDoc))
            : null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(
          context, e.stackTrace.toString() + " " + e.message.toString());
    }

    return userModel;
  }

  Future signout() async {
    await firebaseAuth.signOut();
  }
}
