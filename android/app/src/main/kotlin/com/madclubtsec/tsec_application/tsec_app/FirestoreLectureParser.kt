package com.madclubtsec.tsec_application.tsec_app

import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

/**
 * FirestoreLectureParser
 *
 * Firestore's REST API doesn't return plain JSON — every value is wrapped
 * with its type, e.g. a lecture name looks like:
 *   "lectureName": { "stringValue": "MDM" }
 * instead of just:
 *   "lectureName": "MDM"
 *
 * This unwraps that and rebuilds the SAME simple JSON array format
 * TimetableData.parseLectures() already knows how to read — so nothing
 * else in the widget code needs to change.
 *
 * Also mirrors getTimetablebyDay() from timetable_util.dart exactly:
 * keep a lecture only if lectureBatch matches the student's batch, or is
 * "All".
 */
object FirestoreLectureParser {

    // Calendar.DAY_OF_WEEK: SUNDAY=1 ... SATURDAY=7 — index lines up with this array.
    private val DAY_NAMES = arrayOf(
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    )

    /**
     * @param firestoreRestJson raw response body from FirestoreApiService.getTimetableDoc()
     * @param batch the student's batch, e.g. "B1"
     * @return a JSON array string, e.g. [{"lectureName":"MDM", ...}, ...]
     */
    fun parseTodayLecturesAsJson(firestoreRestJson: String, batch: String): String {
        return try {
            val root = JSONObject(firestoreRestJson)
            val fields = root.optJSONObject("fields") ?: return "[]"

            val todayIndex = Calendar.getInstance().get(Calendar.DAY_OF_WEEK) // 1..7
            val dayKey = DAY_NAMES[todayIndex - 1]

            val dayField = fields.optJSONObject(dayKey) ?: return "[]" // no classes today
            val values = dayField.optJSONObject("arrayValue")
                ?.optJSONArray("values") ?: return "[]"

            val result = JSONArray()
            for (i in 0 until values.length()) {
                val lecFields = values.optJSONObject(i)
                    ?.optJSONObject("mapValue")
                    ?.optJSONObject("fields") ?: continue

                val lectureBatch = stringField(lecFields, "lectureBatch") ?: "All"
                if (lectureBatch != batch && lectureBatch != "All") continue

                val lecture = JSONObject()
                lecture.put("lectureName", stringField(lecFields, "lectureName") ?: "")
                lecture.put("lectureStartTime", stringField(lecFields, "lectureStartTime") ?: "")
                lecture.put("lectureEndTime", stringField(lecFields, "lectureEndTime") ?: "")
                lecture.put(
                    "lectureFacultyName",
                    stringField(lecFields, "lectureFacultyName") ?: " "
                )
                lecture.put("lectureBatch", lectureBatch)
                lecture.put("lectureRoomNo", stringField(lecFields, "lectureRoomNo") ?: "")
                result.put(lecture)
            }
            result.toString()
        } catch (e: Exception) {
            "[]"
        }
    }

    private fun stringField(fields: JSONObject, key: String): String? {
        val f = fields.optJSONObject(key) ?: return null
        return if (f.has("stringValue")) f.getString("stringValue") else null
    }
}
