import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_sound_service.dart';

class IntervalTimerService extends ChangeNotifier {
  final NotificationSoundService _notificationService = NotificationSoundService();
  int runSeconds = 0;
  int walkSeconds = 0;
  int totalCycles = 0;
  int currentCycle = 0;
  int remainingSeconds = 0;
  bool isRunning = false;
  bool isRunPhase = true; // true = run, false = walk
  Timer? _timer;

  void configure({
    required int runMinutes,
    required int walkMinutes,
    required int cycles,
  }) {
    runSeconds = runMinutes * 60;
    walkSeconds = walkMinutes * 60;
    totalCycles = cycles;
    currentCycle = 1;
    remainingSeconds = runSeconds;
    isRunPhase = true;
    isRunning = false;
    notifyListeners();
  }

  void start() {
    if (isRunning) return;

    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        _switchPhase();
      }
    });
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    remainingSeconds = runSeconds;
    currentCycle = 1;
    isRunPhase = true;
    isRunning = false;
    notifyListeners();
  }

  void _switchPhase() {
    if (isRunPhase) {
      // Finished running, start walking
      isRunPhase = false;
      remainingSeconds = walkSeconds;
      _notificationService.showIntervalNotification(
        title: 'MARCHE',
        body: 'Temps de marcher - ${walkSeconds ~/ 60} minute${walkSeconds ~/ 60 > 1 ? 's' : ''}',
      );
    } else {
      // Finished walking, move to next cycle
      currentCycle++;
      if (currentCycle > totalCycles) {
        // Workout complete
        _timer?.cancel();
        isRunning = false;
        _notificationService.showWorkoutCompleteNotification();
        notifyListeners();
        return;
      }
      isRunPhase = true;
      remainingSeconds = runSeconds;
      _notificationService.showIntervalNotification(
        title: 'COURS!',
        body: 'C\'est parti! ${runSeconds ~/ 60} minute${runSeconds ~/ 60 > 1 ? 's' : ''} de course',
      );
    }
    notifyListeners();
  }

  bool get isComplete => currentCycle > totalCycles && !isRunning;

  String get currentPhaseLabel => isRunPhase ? 'COURS!' : 'MARCHE';

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get totalTimeRemaining {
    int remaining = remainingSeconds;

    if (isRunPhase) {
      // Current run + remaining cycles
      final cyclesLeft = totalCycles - currentCycle;
      remaining += walkSeconds + (cyclesLeft * (runSeconds + walkSeconds));
    } else {
      // Current walk + remaining cycles
      final cyclesLeft = totalCycles - currentCycle;
      remaining += cyclesLeft * (runSeconds + walkSeconds);
    }

    return remaining;
  }

  String get formattedTotalTimeRemaining {
    final total = totalTimeRemaining;
    final minutes = total ~/ 60;
    final seconds = total % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
