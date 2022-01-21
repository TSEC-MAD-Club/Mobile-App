import 'package:flutter/foundation.dart';

extension AddTopicsPrefix on String {
  String get addTopicsPrefix => "/topics/$this";
}

abstract class NotificationType {
  static const _testPrefix = kDebugMode ? "test-" : "";

  static const String notification = "${_testPrefix}notification";
}
