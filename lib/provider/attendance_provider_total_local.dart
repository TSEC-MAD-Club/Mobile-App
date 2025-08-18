/*
PURPOSE: TO STORE THE TOTAL ATTENDANCE OF THE USER,
LOCALLY TO REFLECT CHANGES AND NOT FETCH FIREBASE FOR EVERY CALL
THIS IS THE EXACT SAME AS ATTENDANCE_PROVIDER_OVERALL
*/

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceProviderLocal extends StateNotifier<Map<String, int>> {

  AttendanceProviderLocal(super.state);

  void setState(Map<String, int> data) {
    state = Map.from(data);
  }

  int getValue(String key) {
    return state[key] ?? 0;
  }

  void updateValue(String key, String op) {
    int val = state[key] ?? 1;

    if (op == "+") {
      state = {...state, key: val + 1};
    }
    else if (op == "-") {
      state = {...state, key: val - 1};
    }
  }

}

final attendanceTotalLocalProvider = StateNotifierProvider<
    AttendanceProviderLocal,
    Map<String, int>>((ref) {

  return AttendanceProviderLocal({});

});



