package com.zad_al_muslim.adnan

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.IBinder
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileOutputStream

/** Plays exactly one bundled adhan from a foreground media service. */
class AdhanPlaybackService : Service() {
    private var player: MediaPlayer? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val asset = intent?.getStringExtra("asset") ?: return START_NOT_STICKY
        startForeground(NOTIFICATION_ID, notification(intent.getStringExtra("title") ?: "حان وقت الصلاة"))
        stopPlayback()
        try {
            val file = materializeAsset(asset)
            player = MediaPlayer().apply {
                setAudioAttributes(AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
                setDataSource(file.absolutePath)
                setOnCompletionListener { stopSelf(startId) }
                setOnErrorListener { _, _, _ -> stopSelf(startId); true }
                prepare()
                start()
            }
        } catch (_: Exception) {
            stopSelf(startId)
        }
        return START_NOT_STICKY
    }

    private fun materializeAsset(asset: String): File {
        val target = File(cacheDir, "adhan_${asset.substringAfterLast('/')}")
        if (!target.exists()) assets.open("flutter_assets/$asset").use { input ->
            FileOutputStream(target).use { output -> input.copyTo(output) }
        }
        return target
    }

    private fun notification(title: String): android.app.Notification {
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(NotificationChannel(CHANNEL_ID, "زاد المسلم - الأذان", NotificationManager.IMPORTANCE_LOW))
        return NotificationCompat.Builder(this, CHANNEL_ID).setSmallIcon(com.zad_al_muslim.adnan.R.mipmap.ic_launcher).setContentTitle(title).setContentText("جارٍ تشغيل الأذان").setOngoing(true).build()
    }

    private fun stopPlayback() { player?.run { stop(); release() }; player = null }
    override fun onDestroy() { stopPlayback(); super.onDestroy() }
    override fun onBind(intent: Intent?): IBinder? = null
    companion object { private const val CHANNEL_ID = "adhan_playback"; private const val NOTIFICATION_ID = 9251 }
}
