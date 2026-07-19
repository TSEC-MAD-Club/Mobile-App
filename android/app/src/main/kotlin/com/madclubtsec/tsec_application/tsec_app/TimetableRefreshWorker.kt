package com.madclubtsec.tsec_application.tsec_app

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.tasks.await
import java.util.concurrent.TimeUnit

/**
 * TimetableRefreshWorker
 *
 * Runs on a schedule WITHOUT the Flutter engine or app being open at all.
 * Two things happen on every run, roughly every 15 minutes:
 *
 *  1. ALWAYS: redraw the widget against whatever data is already cached in
 *     SharedPreferences. This is cheap (no network) and is what makes the
 *     "currently active lecture" highlight move correctly through the day —
 *     see TimetableData.isCurrentLecture(), which is time-based and just
 *     needs a fresh RemoteViews render to reflect a new "now".
 *
 *  2. ONLY IF the cached data is stale (older than REFRESH_INTERVAL): fetch
 *     fresh data from the Cloud Function via Retrofit, using a Firebase ID
 *     token obtained natively (Firebase Auth's session persists on-device
 *     even when Flutter/the app isn't running).
 */
class TimetableRefreshWorker(
    appContext: Context,
    params: WorkerParameters
) : CoroutineWorker(appContext, params) {

    override suspend fun doWork(): Result {
        val prefs = applicationContext.getSharedPreferences(
            TimetableData.PREFS_NAME, Context.MODE_PRIVATE
        )

        val doc = prefs.getString(TimetableData.KEY_STUDENT_DOC, null)
        val batch = prefs.getString(TimetableData.KEY_STUDENT_BATCH, null)
        if (doc.isNullOrBlank() || batch.isNullOrBlank()) {
            // Nobody's logged in / identity not saved yet — nothing to do.
            return Result.success()
        }

        val now = System.currentTimeMillis()
        val lastFetch = prefs.getLong(TimetableData.KEY_LAST_FETCH, 0L)
        val isStale = (now - lastFetch) > REFRESH_INTERVAL_MS

        if (isStale) {
            val fetchResult = fetchAndCache(prefs, doc, batch, now)
            // If the fetch failed, still fall through to redraw with
            // whatever we already have cached, then ask WorkManager to retry
            // the fetch on the next scheduled run rather than failing loudly.
            if (fetchResult == Result.retry()) {
                refreshAllWidgets(applicationContext)
                return Result.retry()
            }
        }

        refreshAllWidgets(applicationContext)
        return Result.success()
    }

    private suspend fun fetchAndCache(
        prefs: android.content.SharedPreferences,
        doc: String,
        batch: String,
        now: Long
    ): Result {
        return try {
            val user = FirebaseAuth.getInstance().currentUser ?: return Result.retry()
            val idToken = user.getIdToken(false).await().token ?: return Result.retry()

            val response = RetrofitClient.api.getTimetableDoc(doc, "Bearer $idToken")
            if (response.isSuccessful) {
                val rawFirestoreJson = response.body() ?: return Result.retry()
                val json = FirestoreLectureParser.parseTodayLecturesAsJson(rawFirestoreJson, batch)
                prefs.edit()
                    .putString(TimetableData.KEY_TIMETABLE, json)
                    .putLong(TimetableData.KEY_LAST_FETCH, now)
                    .apply()
                Result.success()
            } else {
                // 401 etc. — token might need a hard refresh next time;
                // getIdToken(true) forces that, worth trying once on retry.
                Result.retry()
            }
        } catch (e: Exception) {
            Result.retry()
        }
    }

    private fun refreshAllWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(ComponentName(context, TimetableWidget::class.java))
        for (id in ids) {
            TimetableWidget.updateAppWidget(context, manager, id)
        }
    }

    companion object {
        private const val WORK_NAME = "timetable_refresh_worker"
        private val REFRESH_INTERVAL_MS = TimeUnit.MINUTES.toMillis(60)

        /**
         * Call from TimetableWidgetReceiver.onEnabled() (first widget placed)
         * and from MainActivity's onCreate() (safe to call repeatedly —
         * KEEP policy means it's a no-op if already scheduled).
         */
        fun schedule(context: Context) {
            val request = PeriodicWorkRequestBuilder<TimetableRefreshWorker>(
                15, TimeUnit.MINUTES // WorkManager's enforced minimum interval
            ).setConstraints(
                Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .build()
            ).build()

            WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                request
            )
        }

        /** For a debug button / testing — runs once, immediately. */
        fun runOnce(context: Context) {
            WorkManager.getInstance(context).enqueue(
                OneTimeWorkRequestBuilder<TimetableRefreshWorker>().build()
            )
        }

        fun cancel(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(WORK_NAME)
        }
    }
}
