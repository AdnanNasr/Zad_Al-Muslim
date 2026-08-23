package com.zad_al_muslim.adnan

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

class AdhanAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val service = Intent(context, AdhanPlaybackService::class.java).apply {
            putExtras(intent)
        }
        ContextCompat.startForegroundService(context, service)
    }
}
