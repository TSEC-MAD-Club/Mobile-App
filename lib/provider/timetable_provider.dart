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
    // ref.watch(timetableServiceProvider),
    data?.yearBranchDivTopic,
  );
}));

// class TimeTableProvider extends StateNotifier<bool> {
//   final TimeTableService _ttService;
//
//   final String? _d;
//   final Ref _ref;
//
//   // TimeTableProvider({ttService, ref, d})
//   //     : _ttService = ttService,
//   //       _ref = ref,
//   //       _d = d,
//   //       super(false);
//
//   TimeTableProvider({ttService, ref, d})
//       : _ttService = ttService,
//         _ref = ref,
//         _d = d,
//         super(false);
//
//   Stream getTimeTable() {
//     // return await _authService.fetchStudentDetails(user, context);
//     return _ttService.getweekTimetable(_d);
//   }
// }

class TimeTableProvider extends StateNotifier<Stream> {
  TimeTableService? _ttService;
  String? _d;
  Ref? _ref;

  // TimeTableProvider({ttService, ref, d})
  //     : _ttService = ttService,
  //       _ref = ref,
  //       _d = d,
  //       super(false);

  TimeTableProvider(ttService, ref, d) : super(Stream.empty()) {
    _ttService = ttService;
    _ref = ref;
    _d = d;
    state = _ttService!.getweekTimetable(_d);
  }
  // Stream getTimeTable() {
  // return await _authService.fetchStudentDetails(user, context);
  // return _ttService.getweekTimetable(_d);
  // }
}

// class CounterNotifier extends StateNotifier<CounterState> {
//   CounterNotifier(int initialCount) : super(CounterState(initialCount));
//
//   void increment() {
//     state = CounterState(state.count + 1);
//   }
//
//   void decrement() {
//     state = CounterState(state.count - 1);
//   }
// }
