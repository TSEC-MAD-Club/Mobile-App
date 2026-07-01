package com.madclubtsec.tsec_application.tsec_app

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

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
        if (intent.action == ACTION_REFRESH_WIDGET) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, TimetableWidget::class.java)
            )
            for (id in ids) {
                TimetableWidget.updateAppWidget(context, manager, id)
            }
        }
    }

    companion object {
        const val ACTION_REFRESH_WIDGET =
            "com.madclubtsec.tsec_application.tsec_app.REFRESH_TIMETABLE_WIDGET"
    }
}
