import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tsec_app/models/bugreport_model/bugreport_model.dart';

class ReportServices {
  static final reportsCollection = FirebaseFirestore.instance.collection("Reports");
  static final reportStorage = FirebaseStorage.instance.ref("Reports");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to update Firestore by adding the new report
  Future<void> addReport(Bugreport report) async {
    final doc = reportsCollection.doc("Reports");
    final get = await doc.get();
    List allReports = get.data()?['allReports'] ?? [];

    final newReport = report.toJson();

    allReports.add(newReport);
    await doc.set({"allReports": allReports});
  }

  // Function to upload image files to storage and return download URLs
  Future<List<String>> getBugImages(List<File> fileImages) async {
    List<String> bugImages = [];
    for (File image in fileImages) {
      final uploadTask = await reportStorage
          .child(_auth.currentUser!.uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(image);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      bugImages.add(downloadUrl);
    }
    return bugImages;
  }
}
