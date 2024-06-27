import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/concession_request_model/concession_request_model.dart';
import 'package:tsec_app/services/concession_service.dart';

final concessionRequestDetailProvider = StateProvider<ConcessionRequestModel?>((ref) {
  return null;
});

class ConcessionProvider extends StateNotifier<bool> {
  final ConcessionService _concessionService;
  final Ref _ref;

  ConcessionProvider({required ConcessionService concessionService, required Ref ref})
      : _concessionService = concessionService,
        _ref = ref,
        super(false);

  Future<void> getConcessionRequestData() async {
    try {
      ConcessionRequestModel? concessionRequestDetail =
      await _concessionService.getConcessionRequest();

      _ref.read(concessionRequestDetailProvider.notifier).state = concessionRequestDetail;

      if (concessionRequestDetail != null) {
        print("Concession request detail data ================================");
        print(concessionRequestDetail.uid);
        print(concessionRequestDetail.time);
        print(concessionRequestDetail.passNum);
        print(concessionRequestDetail.status);
        print(concessionRequestDetail.statusMessage);
      }
    } catch (e) {
      print("Error fetching concession request detail data: $e");
      // Handle error here
    }
  }

}
