import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceDateprovider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class AttendanceDateProvider extends StateNotifier<Map> {
  AttendanceDateProvider() : super({});

  void addEntry(String key, String value) {
    state = {
      ...state,
      key: value,
    };
  }

  void setState(Map data) {
    state = data;
  }

  Map get currentState => state;
}

final dateTimetablePreAbsCanProvider =
    StateNotifierProvider<AttendanceDateProvider, Map>((ref) {
  return AttendanceDateProvider();
});
