package com.madclubtsec.tsec_application.tsec_app

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "tsec_app/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "refreshTimetableWidget" -> {
                        refreshWidget(applicationContext)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // NEW — safe to call on every app start: ExistingPeriodicWorkPolicy.KEEP
        // means this is a no-op if already scheduled (e.g. widget was placed
        // first). Covers the case where the widget is placed before the
        // student's identity has ever been saved to SharedPreferences —
        // TimetableRefreshWorker just no-ops each run until KEY_STUDENT_DOC
        // exists.
        TimetableRefreshWorker.schedule(applicationContext)
    }

    companion object {
        fun refreshWidget(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, TimetableWidget::class.java)
            )
            for (id in ids) {
                TimetableWidget.updateAppWidget(context, manager, id)
            }
        }
    }
}
