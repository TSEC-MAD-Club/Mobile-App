import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/services/timetable_service.dart';
import '../models/timetable_model/timetable_model.dart';

final weekTimetableProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(timetableserviceProvider).getweekTimetable();
});

final timetableProvider = Provider<List<TimetableModel>>((ref) {
  return [];
});
