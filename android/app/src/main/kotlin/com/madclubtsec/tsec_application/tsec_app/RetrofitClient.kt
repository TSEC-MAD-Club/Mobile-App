package com.madclubtsec.tsec_application.tsec_app

import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory

/**
 * RetrofitClient
 *
 * Points at Firestore's own REST API — no custom backend of ours to
 * deploy or maintain. BASE_URL never changes; it's Google's, not yours.
 */
object RetrofitClient {

    private const val BASE_URL = "https://firestore.googleapis.com/"

    val api: FirestoreApiService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(ScalarsConverterFactory.create())
            .build()
            .create(FirestoreApiService::class.java)
    }
}
