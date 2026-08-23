package com.zad_al_muslim.adnan

import android.content.Intent
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.provider.Settings
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val notificationSettingsChannel = "com.zad_al_muslim.adnan/notification_sound_settings"
    private val adhanAlarmChannel = "com.zad_al_muslim.adnan/adhan_alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, notificationSettingsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openApp" -> {
                        startActivity(Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                            putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        })
                        result.success(null)
                    }
                    "openChannel" -> {
                        val channelId = call.argument<String>("channelId")
                        if (channelId.isNullOrBlank()) {
                            result.error("missing_channel_id", "channelId is required", null)
                        } else {
                            startActivity(Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS).apply {
                                putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                                putExtra(Settings.EXTRA_CHANNEL_ID, channelId)
                            })
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, adhanAlarmChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "cancelAll") {
                    cancelAllAdhans()
                    result.success(null)
                    return@setMethodCallHandler
                }
                val id = call.argument<Int>("id")
                if (id == null) {
                    result.error("missing_id", "id is required", null)
                    return@setMethodCallHandler
                }
                when (call.method) {
                    "schedule" -> {
                        val time = call.argument<Long>("timeMillis")
                        val asset = call.argument<String>("asset")
                        if (time == null || asset.isNullOrBlank()) {
                            result.error("invalid_alarm", "timeMillis and asset are required", null)
                        } else {
                            scheduleAdhan(id, time, asset, call.argument<String>("title") ?: "حان وقت الصلاة")
                            result.success(null)
                        }
                    }
                    "cancel" -> { cancelAdhan(id); result.success(null) }
                    else -> result.notImplemented()
                }
            }
    }

    private fun pendingAdhan(id: Int, asset: String = "", title: String = ""): PendingIntent {
        val intent = Intent(this, AdhanAlarmReceiver::class.java).apply {
            action = "com.zad_al_muslim.adnan.PLAY_ADHAN.$id"
            putExtra("asset", asset)
            putExtra("title", title)
        }
        return PendingIntent.getBroadcast(this, id, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun scheduleAdhan(id: Int, time: Long, asset: String, title: String) {
        val alarm = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pending = pendingAdhan(id, asset, title)
        alarm.cancel(pending)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S && !alarm.canScheduleExactAlarms()) {
            alarm.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, time, pending)
        } else {
            alarm.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, time, pending)
        }
        val ids = alarmIds()
        ids.add(id)
        saveAlarmIds(ids)
    }

    private fun cancelAdhan(id: Int) {
        val alarm = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pending = pendingAdhan(id)
        alarm.cancel(pending)
        pending.cancel()
        val ids = alarmIds()
        ids.remove(id)
        saveAlarmIds(ids)
    }

    private fun alarmIds(): MutableSet<Int> = getSharedPreferences("adhan_alarms", Context.MODE_PRIVATE)
        .getStringSet("ids", emptySet())!!.mapNotNull { it.toIntOrNull() }.toMutableSet()

    private fun saveAlarmIds(ids: Set<Int>) {
        getSharedPreferences("adhan_alarms", Context.MODE_PRIVATE).edit()
            .putStringSet("ids", ids.map { it.toString() }.toSet()).apply()
    }

    private fun cancelAllAdhans() {
        val ids = alarmIds().toList()
        ids.forEach { cancelAdhan(it) }
    }
}
