import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/occassion_model/occasion_model.dart';
import 'package:tsec_app/services/occasion_serivce.dart';

final occasionProvider = Provider((ref) {
  return OccasionProvider(occasionServices: ref.read(occasionServicesProvider));
});

final occasionListProvider = StreamProvider((ref) {
  final occasionStreamProvider = ref.read(occasionProvider);
  return occasionStreamProvider.getOccasionDetails();
});

class OccasionProvider {
  final OccasionServices _occasionServices;

  OccasionProvider({required OccasionServices occasionServices})
      : _occasionServices = occasionServices;

  Stream<List<OccasionModel>?> getOccasionDetails() {
    return _occasionServices.getOccasionDetails();
  }
}
