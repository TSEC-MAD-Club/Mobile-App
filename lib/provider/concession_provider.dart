import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/concession_details_model/concession_details_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/services/concession_service.dart';
import 'package:tsec_app/utils/notification_type.dart';
import 'package:tsec_app/utils/railway_enum.dart';

final concessionDetailsProvider = StateProvider<ConcessionDetailsModel?>((ref) {
  return null;
});

final concessionProvider =
    StateNotifierProvider<ConcessionProvider, bool>(((ref) {
  return ConcessionProvider(
      ref: ref, concessionService: ref.watch(concessionServiceProvider));
}));

class ConcessionProvider extends StateNotifier<bool> {
  final ConcessionService _concessionService;

  final Ref _ref;

  ConcessionProvider({concessionService, ref})
      : _concessionService = concessionService,
        _ref = ref,
        super(false);

  Future applyConcession(ConcessionDetailsModel concessionDetails,
      File idCardPhoto, File previousPassPhoto, BuildContext context) async {
    concessionDetails.status = ConcessionStatus.unserviced;
    concessionDetails.statusMessage =
        await _concessionService.getWaitingMessage();
    _ref.read(concessionDetailsProvider.notifier).state = concessionDetails;
    ConcessionDetailsModel concessionDetailsData = await _concessionService
        .applyConcession(concessionDetails, idCardPhoto, previousPassPhoto);

    _ref.read(concessionDetailsProvider.notifier).state = concessionDetailsData;
  }

  Future getConcessionData() async {
    ConcessionDetailsModel? concessionDetailsData =
        await _concessionService.getConcessionDetails();
    // debugPrint("concession: ${concessionDetailsData?.firstName}");
    _ref.read(concessionDetailsProvider.notifier).state = concessionDetailsData;
  }

}
