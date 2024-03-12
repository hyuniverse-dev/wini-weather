package com.example.mncf_weather

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.os.Bundle
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "Schedule Notification", // channelId
                "Schedule Notification", // channelName, 여기서는 `main.dart`에 명시된 값을 사용했습니다.
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Information about weather" // channelDescription
            }
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
