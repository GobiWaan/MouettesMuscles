import '../models/workout.dart';
import '../models/run.dart';

class WorkoutCycleService {
  // Workout cycle: Pull -> Push -> Legs -> Run -> repeat
  static const List<String> workoutCycle = ['pull', 'push', 'legs', 'run'];

  /// Get the next workout in the cycle based on the last workout
  static String getNextWorkout(List<Workout> workouts, List<Run> runs) {
    // If no workouts, start with Pull
    if (workouts.isEmpty && runs.isEmpty) {
      return 'pull';
    }

    // Combine workouts and runs to find the most recent activity
    final allActivities = <Map<String, dynamic>>[];

    for (var workout in workouts) {
      allActivities.add({
        'date': workout.date,
        'type': workout.type,
      });
    }

    for (var run in runs) {
      allActivities.add({
        'date': run.date,
        'type': 'run',
      });
    }

    // Sort by date descending
    allActivities.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    if (allActivities.isEmpty) {
      return 'pull';
    }

    final lastType = allActivities.first['type'] as String;
    final currentIndex = workoutCycle.indexOf(lastType);

    if (currentIndex == -1) {
      return 'pull'; // Fallback
    }

    // Get next in cycle
    final nextIndex = (currentIndex + 1) % workoutCycle.length;
    return workoutCycle[nextIndex];
  }

  /// Get the current position in the cycle (1-4)
  static int getCyclePosition(String workoutType) {
    final index = workoutCycle.indexOf(workoutType);
    return index == -1 ? 1 : index + 1;
  }

  /// Get a user-friendly name for the workout type
  static String getWorkoutDisplayName(String type) {
    switch (type) {
      case 'pull':
        return 'PULL (Tirage)';
      case 'push':
        return 'PUSH (Poussée)';
      case 'legs':
        return 'LEGS (Jambes)';
      case 'run':
        return 'COURSE';
      default:
        return type.toUpperCase();
    }
  }

  /// Get the color for the workout type
  static int getWorkoutColor(String type) {
    switch (type) {
      case 'pull':
        return 0xFF2563eb; // Blue
      case 'push':
        return 0xFFdc2626; // Red
      case 'legs':
        return 0xFF16a34a; // Green
      case 'run':
        return 0xFF9333ea; // Purple
      default:
        return 0xFF2563eb;
    }
  }

  /// Get completion status of last 4 workouts
  static List<Map<String, dynamic>> getRecentCycleStatus(
    List<Workout> workouts,
    List<Run> runs,
  ) {
    final allActivities = <Map<String, dynamic>>[];

    for (var workout in workouts) {
      allActivities.add({
        'date': workout.date,
        'type': workout.type,
      });
    }

    for (var run in runs) {
      allActivities.add({
        'date': run.date,
        'type': 'run',
      });
    }

    allActivities.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return allActivities.take(4).toList();
  }
}
