import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/bugreport_model/bugreport_model.dart';
import 'package:tsec_app/services/bug_report_service.dart';

final reportServicesProvider = Provider<ReportServices>((ref) {
  return ReportServices();
});

class BugreportNotifier extends StateNotifier<List<Bugreport>> {
  final ReportServices _reportServices;

  BugreportNotifier(this._reportServices) : super([]);

  // Add a new report
  Future<void> addBugreport(String title, String description, List<File> imagePaths, String uid) async {
    try {
      List<File> files = imagePaths;
      List<String> attachments = await _reportServices.getBugImages(files);

      Bugreport newReport = Bugreport(
        title: title,
        description: description,
        attachments: attachments,
        isResolved: false,
        reportTime: DateTime.now(),
        userUid: uid,
      );

      await _reportServices.addReport(newReport);
      state = [...state, newReport];
    } catch (e) {
      print('Error adding bug report: $e');
    }
  }

}

final bugreportNotifierProvider = StateNotifierProvider<BugreportNotifier, List<Bugreport>>((ref) {
  final reportServices = ref.watch(reportServicesProvider);
  return BugreportNotifier(reportServices);
});
