import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tsec_app/models/class_model/class_model.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/utils/profile_details.dart';
import 'package:tsec_app/utils/railway_enum.dart';
// import 'package:tsec_app/utils/custom_snackbar.dart';

final notesServiceProvider = Provider((ref) {
  return NotesService(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

class NotesService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  NotesService(this.firebaseAuth, this.firebaseFirestore, this.firebaseStorage);
  CollectionReference<Map<String, dynamic>> notesCollection =
      FirebaseFirestore.instance.collection('Notes');

  Stream<User?> get userCurrentState => firebaseAuth.authStateChanges();

  User? get user => firebaseAuth.currentUser;

  Future<List<String>> uploadAttachments(FilePickerResult? files) async {
    if (files == null) return [];

    List<PlatformFile> fileList = files.files.toSet().toList();
    List<String> fileDownloadUrls = [];
    for (PlatformFile file in fileList) {
      File fileFormat = File(file.path ?? "");
      var fileRef = await firebaseStorage
          .ref()
          .child("notes_attachments")
          .child(fileFormat.path.split("/").last)
          .putFile(fileFormat);
      // final String fileName = _selectedFile!.path.split('/').last; // Get the original file name
      // final Reference fileReference = storageReference.child(fileName);
      var downloadURL = await fileRef.ref.getDownloadURL();
      fileDownloadUrls.add(downloadURL);
    }
    return fileDownloadUrls;
  }

  Future<Map<DateTime, List<NotesModel>>> fetchNotes(UserModel? user) async {
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    if (user == null) return Map<DateTime, List<NotesModel>>();
    if (user.isStudent) {
      // debugPrint(
      //     "${user.studentModel?.branch}, ${user.studentModel?.div}, ${calcGradYear(user.studentModel!.gradyear)}");
      querySnapshot = await notesCollection
          .where(
            'target_classes',
            arrayContains: {
              "branch": user.studentModel?.branch,
              "division": user.studentModel?.div,
              "year": calcGradYear(user.studentModel!.gradyear),
            },
          )
          .orderBy("time", descending: true)
          .get();
    } else {
      querySnapshot = await notesCollection
          .where("professor_name", isEqualTo: user.facultyModel?.name)
          .get();
    }
    Map<DateTime, List<NotesModel>> reqNotes =
        Map<DateTime, List<NotesModel>>();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      var noteData = document.data();
      NotesModel note = NotesModel.fromJson(noteData);
      note.id = document.id;
      // debugPrint("wtsf");
      if (reqNotes[note.time] != null)
        reqNotes[note.time] = [...reqNotes[note.time]!, note];
      else
        reqNotes[note.time] = [note];
      // notesList.add(note);
    }
    return reqNotes;
  }

  Future<NotesModel> uploadNote(NotesModel note) async {
    try {
      if (note.id != "") {
        // try {
        //   // Try to update the existing document
        //   await notesDoc.update(note.toJson());
        //   print('Document updated successfully!');
        // } catch (e) {
        //   // If the document doesn't exist, create a new one
        //   if (e is FirebaseException && e.code == 'not-found') {
        //     DocumentReference<Map<String, dynamic>> noteUploaded =
        //         await notesCollection.add(note.toJson());
        //     note.id = noteUploaded.id;
        //     print('Document created successfully!');
        //   } else {
        //     // Handle other errors
        //     print('Error updating or creating document: $e');
        //   }
        // }
        DocumentReference notesDoc = notesCollection.doc(note.id);
        await notesDoc.update(note.toJson());
      } else {
        DocumentReference<Map<String, dynamic>> noteUploaded =
            await notesCollection.add(note.toJson());
        note.id = noteUploaded.id;
      }
    } catch (e) {
      debugPrint('Error updating or creating document: $e');
    }

    return note;
  }

  Future deleteNote(String noteId) async {
    try {
      DocumentReference documentReference = notesCollection.doc(noteId);
      await documentReference.delete();
    } catch (e) {
      debugPrint('Error updating or creating document: $e');
    }
  }
}
