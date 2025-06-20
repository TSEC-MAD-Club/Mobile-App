import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceDateprovider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
