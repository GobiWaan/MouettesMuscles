import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'notification_sound_service.dart';

class RestTimerService extends ChangeNotifier {
  final NotificationSoundService _notificationService = NotificationSoundService();
  static const int defaultDuration = 300; // 5 minutes in seconds

  int _remainingSeconds = defaultDuration;
  Timer? _timer;
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (_timer != null) return;

    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        _timer = null;
        _isRunning = false;
        notifyListeners();
        // Show notification and play sound when timer ends
        _notificationService.showRestTimerNotification();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = defaultDuration;
    _isRunning = false;
    notifyListeners();
  }

  void addTime(int seconds) {
    _remainingSeconds += seconds;
    notifyListeners();
  }

  void setTime(int seconds) {
    _remainingSeconds = seconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
