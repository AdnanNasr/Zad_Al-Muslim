# Adhan audio (Android)

## Overview and modes

Prayer alert mode reuses `PrayerNotificationAudioMode`: **Adhan** plays the
selected bundled audio; **Notification** uses the existing Android prayer
channel; **Silent** uses the existing vibration-only channel. The Adhan and
Silent channels have no notification sound, so an adhan is never doubled.

## Architecture

`features/adhan/data/reciter_catalog.dart` is the single catalog of bundled
reciters. `AdhanSettings` persists the selected ID and reuses the existing mode
preference. `AdhanAlarmScheduler` schedules a native exact Android alarm only
when the mode is Adhan. `NotificationSchedulerImpl` remains responsible for
the existing visual notification schedule and selects the normal/silent/channel
behavior.

`AdhanAlarmReceiver` starts `AdhanPlaybackService`, a foreground media service.
The service copies only the requested Flutter asset into cache on first use,
then uses one `MediaPlayer`; it releases it on completion/error/destruction.

## Reciters and mapping

| Reciter | Normal | Fajr |
| --- | --- | --- |
| عبد الباسط عبد الصمد | abdulbaset.mp3 | abdulbaset_fajr.mp3 |
| علي أحمد ملا | alimulla.mp3 | alimulla_fajr.mp3 |
| ناصر القطامي | alqatami.mp3 | alqatami_fajr.mp3 |
| عصام السرهِي | aserehy.mp3 | aserehy_fajr.mp3 |
| أحمد جوهر | joshar.mp3 | joshar_fajr.mp3 |
| كفاح العزاوي | kefah.mp3 | kefah_fajr.mp3 |
| رياض النقشبندي | riad.mp3 | riad_fajr.mp3 |

Fajr maps strictly to `*_fajr.mp3`; Dhuhr, Asr, Maghrib and Isha map to the
normal file. Sunrise follows the existing optional notification schedule but
is not an adhan prayer and is not armed for native audio.

## Assets, errors, and update behavior

`assets/sounds/` was already registered in `pubspec.yaml`. The catalog contains
only complete file pairs discovered there. An unknown persisted ID safely uses
the default catalog entry. Native playback failures stop only the media service;
the visual notification continues. There is deliberately no fallback from a
missing Fajr file to another reciter or normal file.

Changing mode/reciter forces the existing seven-day schedule to refresh; native
alarm IDs are persisted and cancelled before replacement. No dependencies were
added.

## Background execution and limitations

Android's receiver/foreground media service supports background, locked-screen,
and process-not-running delivery as far as Android permits. Exact-alarm access,
notification permission, OEM battery restrictions, user-disabled foreground
service behavior, and force-stop can still prevent or delay playback. On Android
12+ without exact-alarm access the implementation falls back to an
allow-while-idle inexact alarm. Boot re-scheduling relies on the app's existing
scheduled-notification boot receiver/app lifecycle; device-level testing is
still required before claiming production behavior for a given OEM.

## Files and testing

Created: reciter model/catalog, settings/alarm services, settings dialog,
native receiver/service, catalog test, and this document. Modified:
`NotificationSchedulerImpl`, settings page, `MainActivity`, and Android
manifest. Run `dart format`, `dart analyze`, `flutter test`, then test each
mode and Fajr mapping on a physical Android device. Future work: native boot
rescheduling independent of Flutter and optional foreground-only preview.
