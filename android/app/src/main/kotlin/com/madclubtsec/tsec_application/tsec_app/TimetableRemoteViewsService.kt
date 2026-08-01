package com.madclubtsec.tsec_application.tsec_app

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.widget.RemoteViewsService

/**
 * TimetableRemoteViewsService.kt
 *
 * Provides the scrollable list content for the timetable widget.
 *
 * App widgets cannot reliably scroll a plain ScrollView of manually-added
 * views — the officially supported way to get a scrollable list inside a
 * RemoteViews widget is a ListView/GridView/StackView bound to a
 * RemoteViewsService. This service supplies one row per lecture, with no
 * cap on how many lectures are shown (the old version stopped at 5).
 */
class TimetableRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TimetableRemoteViewsFactory(applicationContext)
    }
}

class TimetableRemoteViewsFactory(
    private val context: Context
) : RemoteViewsService.RemoteViewsFactory {

    private var lectures: List<LectureEntry> = emptyList()

    override fun onCreate() {
        // Nothing to set up up front — data is (re)loaded in onDataSetChanged.
    }

    override fun onDataSetChanged() {
        // Called whenever notifyAppWidgetViewDataChanged() fires, i.e. every
        // time TimetableWidget.updateAppWidget() runs. Re-read the latest
        // timetable JSON written by the Flutter side.
        val prefs: SharedPreferences =
            context.getSharedPreferences(TimetableData.PREFS_NAME, Context.MODE_PRIVATE)
        val json = prefs.getString(TimetableData.KEY_TIMETABLE, null)
        lectures = TimetableData.parseLectures(json)
    }

    override fun onDestroy() {
        lectures = emptyList()
    }

    override fun getCount(): Int = lectures.size

    override fun getViewAt(position: Int): RemoteViews {
        val lec = lectures[position]
        val rowView = RemoteViews(context.packageName, R.layout.widget_lecture_row)

        rowView.setTextViewText(R.id.lec_time, "${lec.startTime} - ${lec.endTime}")
        rowView.setTextViewText(R.id.lec_name, lec.name)
        rowView.setTextViewText(R.id.lec_room, lec.roomNo)
        rowView.setTextViewText(R.id.lec_type, lec.type)

        // Highlight current lecture
        val isNow = TimetableData.isCurrentLecture(lec.startTime, lec.endTime)
        val bgRes = if (isNow) R.drawable.bg_lecture_active else R.drawable.bg_lecture_card
        rowView.setInt(R.id.lec_card_root, "setBackgroundResource", bgRes)

        // Dot colour
        val dotColor = if (isNow) 0xFF5B9BF8.toInt() else 0xFF8899AA.toInt()
        rowView.setInt(R.id.lec_dot, "setColorFilter", dotColor)

        // Lets each row be tapped to open the app (see setPendingIntentTemplate
        // + setOnClickFillInIntent wiring in TimetableWidget.kt).
        rowView.setOnClickFillInIntent(R.id.lec_card_root, Intent())

        return rowView
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
