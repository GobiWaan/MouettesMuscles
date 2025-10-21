import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NotificationSoundService {
  static final NotificationSoundService _instance = NotificationSoundService._internal();
  factory NotificationSoundService() => _instance;
  NotificationSoundService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> initialize() async {
    // Android initialization
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS initialization
    const darwinInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: darwinInitialize,
      macOS: darwinInitialize,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Request permissions on iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request permissions on Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Play custom bell sound and vibrate
  Future<void> playAlert({bool vibrate = true}) async {
    try {
      // Play custom bell sound
      await _audioPlayer.play(
        AssetSource('undertakers-bell-1.mp3'),
        volume: 1.0,
      );
    } catch (e) {
      print('Audio playback error: $e');
    }

    // Vibrate if supported
    if (vibrate) {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        // Vibrate pattern: 500ms on, 200ms off, 500ms on
        Vibration.vibrate(pattern: [0, 500, 200, 500]);
      }
    }
  }

  // Show notification for rest timer
  Future<void> showRestTimerNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'rest_timer',
      'Rest Timer',
      channelDescription: 'Notifications for rest timer completion',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Repos terminé!',
      'C\'est l\'heure de reprendre l\'entraînement 💪',
      notificationDetails,
    );

    await playAlert();
  }

  // Show notification for interval phase change
  Future<void> showIntervalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'interval_timer',
      'Interval Timer',
      channelDescription: 'Notifications for interval timer phase changes',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      ongoing: true, // Keep notification visible
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
    );

    await playAlert();
  }

  // Show notification when workout is complete
  Future<void> showWorkoutCompleteNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'workout_complete',
      'Workout Complete',
      channelDescription: 'Notifications for workout completion',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      2,
      'Entraînement terminé! 🎉',
      'Bravo! Tu as complété ton workout',
      notificationDetails,
    );

    await playAlert();
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
