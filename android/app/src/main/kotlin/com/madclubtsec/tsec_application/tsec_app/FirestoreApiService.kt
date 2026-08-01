package com.madclubtsec.tsec_application.tsec_app

import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path

/**
 * FirestoreApiService
 *
 * Talks DIRECTLY to Firestore's own built-in REST API — no custom backend
 * of ours needed, no Cloud Functions deploy, no extra Google Cloud
 * permissions beyond what your Firebase Auth login already has.
 *
 * This hits the exact same "TimeTable/{docId}" document your Flutter app
 * already reads via the Firestore SDK — just over plain HTTP instead of
 * the SDK. Firestore's normal security rules still apply (whatever lets
 * your Flutter app read this doc today will let this call succeed too).
 *
 * The response is Firestore's own REST JSON format, which wraps every
 * field like {"stringValue": "..."} — see FirestoreLectureParser.kt for
 * how we unwrap it back into the plain JSON your widget already expects.
 */
interface FirestoreApiService {

    @GET("v1/projects/tsec-app/databases/(default)/documents/TimeTable/{docId}")
    suspend fun getTimetableDoc(
        @Path("docId") docId: String,
        @Header("Authorization") bearerToken: String
    ): Response<String>
}
