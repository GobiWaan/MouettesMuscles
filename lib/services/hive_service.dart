import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';
import '../models/run.dart';
import '../models/weight.dart';

class HiveService {
  static const String workoutsBoxName = 'workouts';
  static const String runsBoxName = 'runs';
  static const String weightsBoxName = 'weights';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(RunAdapter());
    Hive.registerAdapter(WeightAdapter());

    // Open boxes
    await Hive.openBox<Workout>(workoutsBoxName);
    await Hive.openBox<Run>(runsBoxName);
    await Hive.openBox<Weight>(weightsBoxName);
  }

  // Get boxes
  static Box<Workout> getWorkoutsBox() => Hive.box<Workout>(workoutsBoxName);
  static Box<Run> getRunsBox() => Hive.box<Run>(runsBoxName);
  static Box<Weight> getWeightsBox() => Hive.box<Weight>(weightsBoxName);

  // Workout operations
  static Future<void> addWorkout(Workout workout) async {
    final box = getWorkoutsBox();
    await box.put(workout.id.millisecondsSinceEpoch.toString(), workout);
  }

  static Future<void> deleteWorkout(String key) async {
    final box = getWorkoutsBox();
    await box.delete(key);
  }

  static List<Workout> getAllWorkouts() {
    final box = getWorkoutsBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<Workout> getWorkoutsByType(String type) {
    return getAllWorkouts().where((w) => w.type == type).toList();
  }

  // Run operations
  static Future<void> addRun(Run run) async {
    final box = getRunsBox();
    await box.put(run.id.millisecondsSinceEpoch.toString(), run);
  }

  static Future<void> deleteRun(String key) async {
    final box = getRunsBox();
    await box.delete(key);
  }

  static List<Run> getAllRuns() {
    final box = getRunsBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Weight operations
  static Future<void> addWeight(Weight weight) async {
    final box = getWeightsBox();
    await box.put(weight.id.millisecondsSinceEpoch.toString(), weight);
  }

  static Future<void> deleteWeight(String key) async {
    final box = getWeightsBox();
    await box.delete(key);
  }

  static List<Weight> getAllWeights() {
    final box = getWeightsBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // Statistics helpers
  static int? getPersonalRecord(String type, String? exercise) {
    final workouts = getWorkoutsByType(type);
    if (workouts.isEmpty) return null;

    int? maxReps;
    for (var workout in workouts) {
      int? reps;
      if (type == 'pull') {
        reps = workout.pullups1;
      } else if (type == 'push') {
        if (exercise == 'dips') {
          reps = workout.dipsOrPike == 'dips' ? workout.dips1 : null;
        } else if (exercise == 'pike') {
          reps = workout.dipsOrPike == 'pike' ? workout.pike1 : null;
        }
      } else if (type == 'legs') {
        if (exercise == 'squat') {
          reps = workout.squatOrDeadlift == 'squat' ? workout.squat1 : null;
        } else if (exercise == 'deadlift') {
          reps = workout.squatOrDeadlift == 'deadlift' ? workout.deadlift1 : null;
        }
      }

      if (reps != null && (maxReps == null || reps > maxReps)) {
        maxReps = reps;
      }
    }
    return maxReps;
  }

  // Clear all data (for testing/debugging)
  static Future<void> clearAllData() async {
    await getWorkoutsBox().clear();
    await getRunsBox().clear();
    await getWeightsBox().clear();
  }
}
