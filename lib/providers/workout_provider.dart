import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../services/hive_service.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  WorkoutProvider() {
    loadWorkouts();
  }

  void loadWorkouts() {
    _workouts = HiveService.getAllWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await HiveService.addWorkout(workout);
    loadWorkouts();
  }

  Future<void> deleteWorkout(String key) async {
    await HiveService.deleteWorkout(key);
    loadWorkouts();
  }

  List<Workout> getWorkoutsByType(String type) {
    return _workouts.where((w) => w.type == type).toList();
  }

  // Get last N workouts of a specific type
  List<Workout> getLastNWorkouts(String type, int n) {
    final filtered = getWorkoutsByType(type);
    return filtered.take(n).toList();
  }

  // Get personal records
  int? getPullupsPR() {
    final pullWorkouts = getWorkoutsByType('pull');
    if (pullWorkouts.isEmpty) return null;
    return pullWorkouts.map((w) => w.pullups1 ?? 0).reduce((a, b) => a > b ? a : b);
  }

  int? getDipsPR() {
    return HiveService.getPersonalRecord('push', 'dips');
  }

  int? getPikePR() {
    return HiveService.getPersonalRecord('push', 'pike');
  }

  int? getSquatPR() {
    return HiveService.getPersonalRecord('legs', 'squat');
  }

  int? getDeadliftPR() {
    return HiveService.getPersonalRecord('legs', 'deadlift');
  }

  // Get total workout count
  int get totalWorkoutCount => _workouts.length;

  // Get workout count by type
  int getWorkoutCountByType(String type) {
    return getWorkoutsByType(type).length;
  }

  // Get total reps for each exercise (ALL TIME)
  int getTotalReps(String exercise) {
    int total = 0;
    for (var workout in _workouts) {
      switch (exercise) {
        case 'pullups':
          total += (workout.pullups1 ?? 0) +
              (workout.pullups2 ?? 0) +
              (workout.pullups2Negatives ?? 0) +
              (workout.pullups2NegativesFinal ?? 0);
          break;
        case 'bicepsCurls':
          total += (workout.bicepsCurls ?? 0) + (workout.bicepsCurlsNegatives ?? 0);
          break;
        case 'dips':
          total += (workout.dips1 ?? 0) +
              (workout.dips2 ?? 0) +
              (workout.dips2Negatives ?? 0) +
              (workout.dips2NegativesFinal ?? 0);
          break;
        case 'pike':
          total += (workout.pike1 ?? 0) +
              (workout.pike2 ?? 0) +
              (workout.pike2Negatives ?? 0) +
              (workout.pike2NegativesFinal ?? 0);
          break;
        case 'squats':
          if (workout.squatOrDeadlift == 'squat') {
            total += (workout.squat1 ?? 0) +
                (workout.squat2 ?? 0) +
                (workout.squat3 ?? 0);
          }
          break;
        case 'deadlifts':
          if (workout.squatOrDeadlift == 'deadlift') {
            total += (workout.deadlift1 ?? 0) +
                (workout.deadlift2 ?? 0);
          }
          break;
        case 'backExtension':
          total += (workout.backExtension ?? 0) + (workout.backExtension2 ?? 0);
          break;
        case 'legRaises':
          total += (workout.legRaises ?? 0) + (workout.legRaises2 ?? 0);
          break;
        case 'qlExtension':
          total += (workout.qlExtension ?? 0) + (workout.qlExtension2 ?? 0);
          break;
      }
    }
    return total;
  }
}
