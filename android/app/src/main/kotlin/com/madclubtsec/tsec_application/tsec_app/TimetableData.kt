//package com.madclubtsec.tsec_application.tsec_app
//
//import org.json.JSONArray
//import org.json.JSONObject
//import java.text.SimpleDateFormat
//import java.util.*
//
///**
// * TimetableData.kt
// *
// * Shared parsing / helper logic for the timetable widget.
// * Extracted out of TimetableWidget.kt so that both:
// *  - TimetableWidget.kt (draws the header, wires up the scrollable list)
// *  - TimetableRemoteViewsService.kt (builds each row of the scrollable list)
// * use exactly the same JSON parsing and "is this lecture happening right now"
// * logic, instead of two copies drifting apart.
// *
// * Data flow:
// *  Flutter app  →  SharedPreferences (key: "flutter.timetable_today")  →  widget
// *
// * JSON array format (each element):
// * {
// *   "lectureName":      "MDM",
// *   "lectureStartTime": "09:00",
// *   "lectureEndTime":   "10:00",
// *   "lectureFacultyName": "Dr. Smith",
// *   "lectureBatch":     "All",
// *   "lectureRoomNo":    "Room 301",   // optional
// *   "lectureType":      "Lecture"     // optional – derived from name if absent
// * }
// */
//
//data class LectureEntry(
//    val name: String,
//    val startTime: String,
//    val endTime: String,
//    val faculty: String,
//    val batch: String,
//    val roomNo: String,
//    val type: String
//)
//
//object TimetableData {
//
//    // Flutter stores prefs in a file named "FlutterSharedPreferences".
//    // All keys written via Flutter's shared_preferences plugin are prefixed
//    // with "flutter." automatically.
//    const val PREFS_NAME    = "FlutterSharedPreferences"
//    const val KEY_TIMETABLE = "flutter.timetable_today"   // JSON array
//    const val KEY_DAY_LABEL = "flutter.timetable_day"     // e.g. "Tuesday"
//
//    // NEW — written once by Flutter after login via
//    // TimetableWidgetHelper.saveStudentIdentity(), e.g. "2024-COMPS-A".
//    // Read by TimetableRefreshWorker so it knows which doc to fetch without
//    // Flutter running.
//    const val KEY_STUDENT_DOC = "flutter.timetable_student_doc"
//
//    // NEW — the student's batch, e.g. "B1". Needed because a lecture only
//    // belongs to a student if lectureBatch == this batch OR == "All"
//    // (mirrors getTimetablebyDay() in timetable_util.dart).
//    const val KEY_STUDENT_BATCH = "flutter.timetable_student_batch"
//
//    // NEW — set natively by TimetableRefreshWorker after each successful
//    // network fetch, used to decide when cached data is stale.
//    const val KEY_LAST_FETCH = "native.timetable_last_fetch"
//
//    fun parseLectures(json: String?): List<LectureEntry> {
//        if (json.isNullOrBlank()) return emptyList()
//        return try {
//            val arr = JSONArray(json)
//            (0 until arr.length()).map { i ->
//                val obj: JSONObject = arr.getJSONObject(i)
//                LectureEntry(
//                    name      = obj.optString("lectureName", "—"),
//                    startTime = obj.optString("lectureStartTime", ""),
//                    endTime   = obj.optString("lectureEndTime", ""),
//                    faculty   = obj.optString("lectureFacultyName", ""),
//                    batch     = obj.optString("lectureBatch", "All"),
//                    roomNo    = obj.optString("lectureRoomNo", ""),
//                    type      = deriveType(obj)
//                )
//            }
//        } catch (e: Exception) {
//            emptyList()
//        }
//    }
//
//    private fun deriveType(obj: JSONObject): String {
//        val explicit = obj.optString("lectureType", "")
//        if (explicit.isNotBlank()) return explicit
//        val name = obj.optString("lectureName", "").lowercase()
//        return when {
//            name.endsWith("lab") || name.endsWith("labs") -> "Practical"
//            name.contains("tutorial") -> "Tutorial"
//            else -> "Lecture"
//        }
//    }
//
//    /**
//     * Returns true if the current time falls within [startTime, endTime].
//     * Times are expected as "HH:mm" (24-hour).
//     */
//    fun isCurrentLecture(startTime: String, endTime: String): Boolean {
//        return try {
//            val fmt = SimpleDateFormat("HH:mm", Locale.getDefault())
//            val now = Calendar.getInstance()
//            val start = Calendar.getInstance().apply {
//                time = fmt.parse(startTime) ?: return false
//                set(Calendar.YEAR, now.get(Calendar.YEAR))
//                set(Calendar.MONTH, now.get(Calendar.MONTH))
//                set(Calendar.DAY_OF_MONTH, now.get(Calendar.DAY_OF_MONTH))
//            }
//            val end = Calendar.getInstance().apply {
//                time = fmt.parse(endTime) ?: return false
//                set(Calendar.YEAR, now.get(Calendar.YEAR))
//                set(Calendar.MONTH, now.get(Calendar.MONTH))
//                set(Calendar.DAY_OF_MONTH, now.get(Calendar.DAY_OF_MONTH))
//            }
//            now.after(start) && now.before(end)
//        } catch (e: Exception) {
//            false
//        }
//    }
//}

package com.madclubtsec.tsec_application.tsec_app

import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

/**
 * TimetableData.kt
 *
 * Shared parsing / helper logic for the timetable widget.
 * Extracted out of TimetableWidget.kt so that both:
 *  - TimetableWidget.kt (draws the header, wires up the scrollable list)
 *  - TimetableRemoteViewsService.kt (builds each row of the scrollable list)
 * use exactly the same JSON parsing and "is this lecture happening right now"
 * logic, instead of two copies drifting apart.
 *
 * Data flow:
 *  Flutter app  →  SharedPreferences (key: "flutter.timetable_today")  →  widget
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

data class LectureEntry(
    val name: String,
    val startTime: String,
    val endTime: String,
    val faculty: String,
    val batch: String,
    val roomNo: String,
    val type: String
)

object TimetableData {

    // Flutter stores prefs in a file named "FlutterSharedPreferences".
    // All keys written via Flutter's shared_preferences plugin are prefixed
    // with "flutter." automatically.
    const val PREFS_NAME    = "FlutterSharedPreferences"
    const val KEY_TIMETABLE = "flutter.timetable_today"   // JSON array
    const val KEY_DAY_LABEL = "flutter.timetable_day"     // e.g. "Tuesday"

    // NEW — written once by Flutter after login via
    // TimetableWidgetHelper.saveStudentIdentity(), e.g. "2024-COMPS-A".
    // Read by TimetableRefreshWorker so it knows which doc to fetch without
    // Flutter running.
    const val KEY_STUDENT_DOC = "flutter.timetable_student_doc"

    // NEW — the student's batch, e.g. "B1". Needed because a lecture only
    // belongs to a student if lectureBatch == this batch OR == "All"
    // (mirrors getTimetablebyDay() in timetable_util.dart).
    const val KEY_STUDENT_BATCH = "flutter.timetable_student_batch"

    // NEW — set natively by TimetableRefreshWorker after each successful
    // network fetch, used to decide when cached data is stale.
    const val KEY_LAST_FETCH = "native.timetable_last_fetch"

    fun parseLectures(json: String?): List<LectureEntry> {
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
     *
     * Times are stored as 12-hour clock strings with an am/pm suffix, e.g.
     * "9:15 am", "1:00 pm" — NOT 24-hour "09:15"/"13:00". This must stay
     * "h:mm a", not "HH:mm": SimpleDateFormat is lenient by default, so
     * parsing "1:00 pm" against "HH:mm" doesn't throw — it silently reads
     * just "1:00" and drops the "pm", parsing it as 1 AM instead of 1 PM.
     * That's exactly the bug that made afternoon lectures highlight 12
     * hours off (mornings looked fine only because e.g. "9:15 am" happens
     * to numerically match its own 24-hour form).
     */
    fun isCurrentLecture(startTime: String, endTime: String): Boolean {
        return try {
            // Locale.US (not getDefault()) because the am/pm text in the
            // data is always English regardless of the phone's locale, and
            // .uppercase() so it matches regardless of whether Firestore
            // has "am"/"pm" or "AM"/"PM".
            val fmt = SimpleDateFormat("h:mm a", Locale.US)
            val now = Calendar.getInstance()
            val start = Calendar.getInstance().apply {
                time = fmt.parse(startTime.uppercase(Locale.US)) ?: return false
                set(Calendar.YEAR, now.get(Calendar.YEAR))
                set(Calendar.MONTH, now.get(Calendar.MONTH))
                set(Calendar.DAY_OF_MONTH, now.get(Calendar.DAY_OF_MONTH))
            }
            val end = Calendar.getInstance().apply {
                time = fmt.parse(endTime.uppercase(Locale.US)) ?: return false
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