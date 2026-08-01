package com.madclubtsec.tsec_application.tsec_app

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.Toast

/**
 * TimetableWidgetReceiver
 *
 * Receives an explicit broadcast that the Flutter side fires whenever it
 * successfully writes new timetable data to SharedPreferences.
 *
 * Flutter usage (in timetable_provider or main_screen.dart):
 *
 *   import 'package:flutter/services.dart';
 *
 *   static const _channel = MethodChannel('tsec_app/widget');
 *
 *   // Call this after saving the timetable to SharedPreferences
 *   await _channel.invokeMethod('refreshTimetableWidget');
 *
 * Register this receiver in AndroidManifest.xml (already included in the
 * manifest snippet provided separately).
 */
class TimetableWidgetReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_REFRESH_WIDGET -> {
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(
                    ComponentName(context, TimetableWidget::class.java)
                )
                for (id in ids) {
                    TimetableWidget.updateAppWidget(context, manager, id)
                }
            }
            // NEW — fired by tapping the refresh icon on the widget itself.
            // forceFetch = true skips the "is cached data older than 1hr"
            // check, so it always hits Firestore right away instead of
            // waiting on the normal schedule.
            ACTION_MANUAL_REFRESH -> {
                Toast.makeText(context, "Refreshing timetable…", Toast.LENGTH_SHORT).show()
                TimetableRefreshWorker.runOnce(context, forceFetch = true)
            }
        }
    }

    companion object {
        const val ACTION_REFRESH_WIDGET =
            "com.madclubtsec.tsec_application.tsec_app.REFRESH_TIMETABLE_WIDGET"
        const val ACTION_MANUAL_REFRESH =
            "com.madclubtsec.tsec_application.tsec_app.MANUAL_REFRESH_TIMETABLE_WIDGET"
    }
}