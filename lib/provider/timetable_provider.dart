import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/services/timetable_service.dart';

final weekTimetableProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(timetableserviceProvider).getweekTimetable();
});
