/*
BOTTOM DESIGN PART FOR CONTAINER BEING THE ATTENDANCE SCREEN

CONTAINS THREE BUTTONS -> CAN (CANCEL), PRE(PRESENT), ABS(ABSENT)

Button taps now only update local pending state.
Firebase writes are deferred until the user taps "Apply Changes".
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/provider/attendance_date_provider.dart';

class DummyContainerBottom extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final String lectureName;
  final int index;

  const DummyContainerBottom({
    super.key,
    required this.width,
    required this.height,
    required this.lectureName,
    required this.index,
  });

  @override
  ConsumerState<DummyContainerBottom> createState() =>
      _DummyContainerBottomState();
}

class _DummyContainerBottomState extends ConsumerState<DummyContainerBottom> {
  Map selected = {};

  /// Returns the effective selection for this subject:
  /// pending change if exists, otherwise the saved (committed) value.
  String? _effectiveSelection() {
    final pending = ref.watch(pendingAttendanceProvider);
    if (pending.containsKey(widget.lectureName)) {
      return pending[widget.lectureName];
    }
    final saved = ref.watch(dateTimetablePreAbsCanProvider);
    return saved[widget.lectureName];
  }

  void _selectAction(String action) {
    // Check what the original saved state was for this subject
    final saved = ref.read(dateTimetablePreAbsCanProvider);
    final originalAction = saved[widget.lectureName];

    if (originalAction == action) {
      // User reverted back to the original saved state, so remove from pending
      ref
          .read(pendingAttendanceProvider.notifier)
          .removePending(widget.lectureName);
    } else {
      // User selected a new state, so add/update pending
      ref
          .read(pendingAttendanceProvider.notifier)
          .setPending(widget.lectureName, action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSelection = _effectiveSelection();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Cancel Button ───
          GestureDetector(
              onTap: () => _selectAction('Can'),
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: currentSelection == 'Can'
                        ? const Color.fromARGB(44, 180, 180, 180)
                        : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.error_outline_outlined,
                      color: Colors.white,
                    ),
                    Text("Can")
                  ],
                ),
              )),
          // ─── Present Button ───
          GestureDetector(
              onTap: () => _selectAction('Pre'),
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                  color: currentSelection == 'Pre'
                      ? const Color.fromARGB(44, 180, 180, 180)
                      : Colors.transparent,
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text("Pre")
                  ],
                ),
              )),
          // ─── Absent Button ───
          GestureDetector(
              onTap: () => _selectAction('Abs'),
              child: Container(
                width: widget.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                    color: currentSelection == 'Abs'
                        ? const Color.fromARGB(44, 180, 180, 180)
                        : Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    Text("Abs")
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

