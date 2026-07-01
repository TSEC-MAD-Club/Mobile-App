package com.madclubtsec.tsec_application.tsec_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

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

    companion object {

        // ── SharedPreferences ────────────────────────────────────────────────
        // Flutter stores prefs in a file named "FlutterSharedPreferences".
        // All keys written via Flutter's shared_preferences plugin are prefixed
        // with "flutter." automatically.
        const val PREFS_NAME      = "FlutterSharedPreferences"
        const val KEY_TIMETABLE   = "flutter.timetable_today"   // JSON array
        const val KEY_DAY_LABEL   = "flutter.timetable_day"     // e.g. "Tuesday"

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs: SharedPreferences =
                context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            // ── Build RemoteViews ────────────────────────────────────────────
            val views = RemoteViews(context.packageName, R.layout.widget_timetable)

            // Date header
            val today = Calendar.getInstance()
            val dayName = SimpleDateFormat("EEEE", Locale.getDefault()).format(today.time)
            val dateStr = SimpleDateFormat("d MMMM", Locale.getDefault()).format(today.time)
            views.setTextViewText(R.id.widget_day_label, dayName)
            views.setTextViewText(R.id.widget_date_label, dateStr)

            // ── Parse timetable JSON ─────────────────────────────────────────
            val json = prefs.getString(KEY_TIMETABLE, null)
            val lectures = parseLectures(json)

            // ── Populate lecture rows (up to 5 shown) ───────────────────────
            val rowIds = listOf(
                R.id.lecture_row_1,
                R.id.lecture_row_2,
                R.id.lecture_row_3,
                R.id.lecture_row_4,
                R.id.lecture_row_5
            )

            for (i in rowIds.indices) {
                if (i < lectures.size) {
                    val lec = lectures[i]
                    val rowView = RemoteViews(context.packageName, R.layout.widget_lecture_row)

                    rowView.setTextViewText(R.id.lec_time,
                        "${lec.startTime} - ${lec.endTime}")
                    rowView.setTextViewText(R.id.lec_name, lec.name)
                    rowView.setTextViewText(R.id.lec_room, lec.roomNo)
                    rowView.setTextViewText(R.id.lec_type, lec.type)

                    // Highlight current lecture
                    val isNow = isCurrentLecture(lec.startTime, lec.endTime)
                    val bgRes = if (isNow)
                        R.drawable.bg_lecture_active
                    else
                        R.drawable.bg_lecture_card

                    rowView.setInt(R.id.lec_card_root, "setBackgroundResource", bgRes)

                    // Dot colour
                    val dotColor = if (isNow) 0xFF5B9BF8.toInt() else 0xFF8899AA.toInt()
                    rowView.setInt(R.id.lec_dot, "setColorFilter", dotColor)

                    views.addView(rowIds[i], rowView)
                } else {
                    // hide unused rows by setting an empty view
                    views.removeAllViews(rowIds[i])
                }
            }

            // Empty state
            if (lectures.isEmpty()) {
                views.setTextViewText(R.id.widget_empty_text, "No classes today 🎉")
                views.setViewVisibility(R.id.widget_empty_text, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_empty_text, android.view.View.GONE)
            }

            // ── Tap to open app ──────────────────────────────────────────────
            val intent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
            if (intent != null) {
                val pendingIntent = PendingIntent.getActivity(
                    context, 0, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // ── Helpers ──────────────────────────────────────────────────────────

        private fun parseLectures(json: String?): List<LectureEntry> {
            if (json.isNullOrBlank()) return emptyList()
            return try {
                val arr = JSONArray(json)
                (0 until arr.length()).map { i ->
                    val obj: JSONObject = arr.getJSONObject(i)
                    LectureEntry(
                        name      = obj.optString("lectureName", "—"),
                        startTime = obj.optString("lectureStartTime", ""),
                        endTime   = obj.optString("lectureEndTime", ""),
                        faculty   = obj.optString("lectureFacultyName", ""),
                        batch     = obj.optString("lectureBatch", "All"),
                        roomNo    = obj.optString("lectureRoomNo", ""),
                        type      = deriveType(obj)
                    )
                }
            } catch (e: Exception) {
                emptyList()
            }
        }

        private fun deriveType(obj: JSONObject): String {
            val explicit = obj.optString("lectureType", "")
            if (explicit.isNotBlank()) return explicit
            val name = obj.optString("lectureName", "").lowercase()
            return when {
                name.endsWith("lab") || name.endsWith("labs") -> "Practical"
                name.contains("tutorial") -> "Tutorial"
                else -> "Lecture"
            }
        }

        /**
         * Returns true if the current time falls within [startTime, endTime].
         * Times are expected as "HH:mm" (24-hour).
         */
        private fun isCurrentLecture(startTime: String, endTime: String): Boolean {
            return try {
                val fmt = SimpleDateFormat("HH:mm", Locale.getDefault())
                val now = Calendar.getInstance()
                val start = Calendar.getInstance().apply {
                    time = fmt.parse(startTime) ?: return false
                    set(Calendar.YEAR, now.get(Calendar.YEAR))
                    set(Calendar.MONTH, now.get(Calendar.MONTH))
                    set(Calendar.DAY_OF_MONTH, now.get(Calendar.DAY_OF_MONTH))
                }
                val end = Calendar.getInstance().apply {
                    time = fmt.parse(endTime) ?: return false
                    set(Calendar.YEAR, now.get(Calendar.YEAR))
                    set(Calendar.MONTH, now.get(Calendar.MONTH))
                    set(Calendar.DAY_OF_MONTH, now.get(Calendar.DAY_OF_MONTH))
                }
                now.after(start) && now.before(end)
            } catch (e: Exception) {
                false
            }
        }
    }

    data class LectureEntry(
        val name: String,
        val startTime: String,
        val endTime: String,
        val faculty: String,
        val batch: String,
        val roomNo: String,
        val type: String
    )
}
