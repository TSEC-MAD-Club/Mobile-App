/**
 * TimetableWidget – Home screen widget that shows today's class schedule.
 *
 * Data flow:
 *  Flutter app  →  SharedPreferences (key: "flutter.timetable_today")  →  this widget
 *
 * The Flutter side must write a JSON array to SharedPreferences every time the
 * timetable is loaded (see TimetableWidgetDataHelper.kt / flutter integration notes).
 *
 * JSON array format (each element):
 * {
 *   "lectureName":      "MDM",
 *   "lectureStartTime": "09:00",
 *   "lectureEndTime":   "10:00",
 *   "lectureFacultyName": "Dr. Smith",
 *   "lectureBatch":     "All",
 *   "lectureRoomNo":    "Room 301",   // optional
 *   "lectureType":      "Lecture"     // optional – derived from name if absent
 * }
 */

package com.madclubtsec.tsec_application.tsec_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.*

/**
 * TimetableWidget – Home screen widget that shows today's class schedule.
 *
 * Data flow:
 *  Flutter app  →  SharedPreferences (key: "flutter.timetable_today")  →  this widget
 *
 * The lecture list itself is scrollable: it's a RemoteViews ListView backed
 * by TimetableRemoteViewsService / TimetableRemoteViewsFactory, which is
 * where the JSON parsing + row-binding now lives (see that file). This
 * class just draws the header/footer chrome and wires the adapter up.
 */
class TimetableWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    // NEW — fires once when the FIRST instance of this widget is placed on
    // a home screen (not on every subsequent placement of additional
    // instances). This is where we kick off the Flutter-independent
    // background refresh job.
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        TimetableRefreshWorker.schedule(context)
    }

    // NEW — fires when the LAST instance of this widget is removed from
    // all home screens. Stop the background job since there's nothing
    // left to update.
    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        TimetableRefreshWorker.cancel(context)
    }

    companion object {

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_timetable)

            // ── Date header ──────────────────────────────────────────────────
            val today = Calendar.getInstance()
            val dayName = SimpleDateFormat("EEEE", Locale.getDefault()).format(today.time)
            val dateStr = SimpleDateFormat("d MMMM", Locale.getDefault()).format(today.time)
            views.setTextViewText(R.id.widget_day_label, dayName)
            views.setTextViewText(R.id.widget_date_label, dateStr)

            // ── Wire up the scrollable lecture list ─────────────────────────
            // Each widget instance needs its own Intent (the appWidgetId must
            // be part of it, and the data Uri must be unique) or Android will
            // treat multiple widget instances as sharing one adapter.
            val adapterIntent = Intent(context, TimetableRemoteViewsService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = android.net.Uri.parse("content://widget/$appWidgetId")
            }
            views.setRemoteAdapter(R.id.lecture_list, adapterIntent)
            views.setEmptyView(R.id.lecture_list, R.id.widget_empty_text)

            // ── Tap a lecture row to open the app ───────────────────────────
            val launchIntent = context.packageManager
                .getLaunchIntentForPackage(context.packageName) ?: Intent()
            val piFlags = PendingIntent.FLAG_UPDATE_CURRENT or
                    (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0)
            val rowClickTemplate = PendingIntent.getActivity(
                context, appWidgetId, launchIntent, piFlags
            )
            views.setPendingIntentTemplate(R.id.lecture_list, rowClickTemplate)

            // ── Tap anywhere else on the widget (header/empty state) to open ─
            val rootPendingIntent = PendingIntent.getActivity(
                context, 0, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, rootPendingIntent)

            // ── Manual refresh button ────────────────────────────────────
            // Separate tap target from widget_root above — Android lets a
            // child view's own click target "win" over a parent's, so
            // tapping this icon specifically triggers an immediate re-fetch
            // instead of just opening the app.
            val refreshIntent = Intent(context, TimetableWidgetReceiver::class.java).apply {
                action = TimetableWidgetReceiver.ACTION_MANUAL_REFRESH
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context, appWidgetId, refreshIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_refresh_button, refreshPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            // Tell the factory to re-read SharedPreferences and rebuild rows.
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.lecture_list)
        }
    }
}
