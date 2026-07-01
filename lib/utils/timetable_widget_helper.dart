import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TimetableWidgetHelper
///
/// Call [saveTodayTimetable] after the timetable is fetched from Firebase
/// (e.g. in timetable_provider.dart or timetable_screen.dart).
///
/// The widget reads the key "flutter.timetable_today" from
/// FlutterSharedPreferences (Flutter's shared_preferences plugin
/// automatically prepends "flutter." to every key).
class TimetableWidgetHelper {
  static const _channel = MethodChannel('tsec_app/widget');

  /// Saves today's lecture list to SharedPreferences so the Android widget
  /// can read it, then asks the widget to refresh.
  ///
  /// [lectures] – list of maps, each with keys:
  ///   lectureName, lectureStartTime, lectureEndTime,
  ///   lectureFacultyName, lectureBatch, lectureRoomNo (optional), lectureType (optional)
  static Future<void> saveTodayTimetable(
      List<Map<String, dynamic>> lectures) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // shared_preferences plugin stores this as "flutter.timetable_today"
      await prefs.setString('timetable_today', jsonEncode(lectures));

      // Tell the native side to redraw the widget
      if (await _isAndroid()) {
        await _channel.invokeMethod('refreshTimetableWidget');
      }
    } catch (_) {
      // Widget refresh is non-critical – silently ignore errors
    }
  }

  static bool _android = false;
  static bool _androidChecked = false;

  static Future<bool> _isAndroid() async {
    if (_androidChecked) return _android;
    _androidChecked = true;
    try {
      // MethodChannel only works on Android; on iOS it throws
      await _channel.invokeMethod('ping');
      _android = true;
    } catch (_) {
      _android = true; // invokeMethod itself means we're on Android
    }
    return _android;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO INTEGRATE  (add these 2 lines wherever you process timetable data)
// ─────────────────────────────────────────────────────────────────────────────
//
// In timetable_screen.dart  (or wherever you call getTimetablebyDay):
//
//   final roomNos = <String>[];
//   final lectures = getTimetablebyDay(data, todayKey, roomNos, ref);
//
//   // Build the list of maps the widget needs:
//   final widgetData = List.generate(lectures.length, (i) {
//     return {
//       'lectureName':       lectures[i].lectureName,
//       'lectureStartTime':  lectures[i].lectureStartTime,
//       'lectureEndTime':    lectures[i].lectureEndTime,
//       'lectureFacultyName': lectures[i].lectureFacultyName,
//       'lectureBatch':      lectures[i].lectureBatch,
//       'lectureRoomNo':     i < roomNos.length ? roomNos[i] : '',
//     };
//   });
//
//   await TimetableWidgetHelper.saveTodayTimetable(widgetData);
//
// ─────────────────────────────────────────────────────────────────────────────
