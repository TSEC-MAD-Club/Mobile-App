// dummy_container_top.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/new_ui/screens/attendance_screen/attendance_totals_provider.dart';

class Dummycontainertop extends ConsumerWidget {
  final String subjectName;

  const Dummycontainertop({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceTotalsProvider(subjectName));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subjectName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        attendanceAsync.when(
          loading: () => const Text("Loading...", style: TextStyle(color: Colors.white70)),
          error: (e, _) => const Text("Error", style: TextStyle(color: Colors.red)),
          data: (data) {
            final percent = data.total == 0 ? 0 : ((data.attended / data.total) * 100).round();
            return Text("Total: ${data.attended}/${data.total} ($percent%)", style: const TextStyle(color: Colors.white70));
          },
        ),
      ],
    );
  }
}
