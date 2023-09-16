import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/timetable_service.dart';
import 'package:tsec_app/utils/notification_type.dart';

// controller
// final weekTimetableProvider = StreamProvider<Map<String, dynamic>?>((ref) {
//   return ref.read(timetableServiceProvider).getweekTimetable();
// });
final counterStreamProvider = StreamProvider((ref) {
  return ref.watch(timeTableProvider);
});

final timeTableProvider =
    StateNotifierProvider<TimeTableProvider, Stream<dynamic>>(((ref) {
  final data = ref.watch(notificationTypeProvider);
  debugPrint("data refereshed ${data?.yearBranchDivTopic}");
  return TimeTableProvider(
    TimeTableService(ref.watch(firestoreProvider)),
    ref,
    data?.yearBranchDivTopic,
  );
}));


class TimeTableProvider extends StateNotifier<Stream> {
  TimeTableService? _ttService;
  String? _d;
  Ref? _ref;

  TimeTableProvider(ttService, ref, d) : super(Stream.empty()) {
    _ttService = ttService;
    _ref = ref;
    _d = d;
    state = _ttService!.getweekTimetable(_d);
  }
}

