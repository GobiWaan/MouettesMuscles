import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  late DateTime id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late String type; // "pull", "push", "legs"

  // Pull workout fields
  @HiveField(3)
  int? pullups1;

  @HiveField(4)
  int? pullups2;

  @HiveField(5)
  int? pullups2Negatives;

  @HiveField(6)
  int? pullups2NegativesFinal;

  @HiveField(7)
  int? bicepsCurls;

  @HiveField(8)
  int? bicepsCurlsNegatives;

  // Push workout fields
  @HiveField(9)
  String? dipsOrPike; // Deprecated: kept for backward compatibility

  @HiveField(10)
  int? dips1;

  @HiveField(11)
  int? dips2;

  @HiveField(12)
  int? dips2Negatives;

  @HiveField(13)
  int? dips2NegativesFinal;

  @HiveField(14)
  int? pike1;

  @HiveField(15)
  int? pike2;

  @HiveField(16)
  int? pike2Negatives;

  @HiveField(17)
  int? pike2NegativesFinal;

  // Legs workout fields
  @HiveField(18)
  String? squatOrDeadlift; // "squat" or "deadlift" - alternates automatically

  // Squat fields
  @HiveField(19)
  int? squat1; // Set 1 reps

  @HiveField(20)
  int? squat2; // Set 2 reps

  @HiveField(21)
  int? squat3; // Set 3 reps (bodyweight) - formerly squat2Negatives

  @HiveField(32)
  double? squat1Weight; // Set 1 weight in lbs

  @HiveField(33)
  double? squat2Weight; // Set 2 weight in lbs

  // Deadlift fields
  @HiveField(22)
  int? deadlift1; // Set 1 reps

  @HiveField(23)
  int? deadlift2; // Set 2 reps

  @HiveField(24)
  int? deadlift2Negatives; // Deprecated - no longer used

  @HiveField(34)
  double? deadlift1Weight; // Set 1 weight in lbs

  @HiveField(35)
  double? deadlift2Weight; // Set 2 weight in lbs

  // Accessory exercises (one per workout type)
  @HiveField(26)
  int? backExtension; // Pull day - Extension dorsale (Set 1)

  @HiveField(27)
  int? legRaises; // Push day - Levées de jambes (abdos) (Set 1)

  @HiveField(28)
  int? qlExtension; // Legs day - Extension QL (Set 1)

  @HiveField(29)
  int? backExtension2; // Pull day - Extension dorsale (Set 2)

  @HiveField(30)
  int? legRaises2; // Push day - Levées de jambes (Set 2)

  @HiveField(31)
  int? qlExtension2; // Legs day - Extension QL (Set 2)

  @HiveField(25)
  String? notes;

  Workout({
    DateTime? id,
    DateTime? date,
    required this.type,
    this.pullups1,
    this.pullups2,
    this.pullups2Negatives,
    this.pullups2NegativesFinal,
    this.bicepsCurls,
    this.bicepsCurlsNegatives,
    this.dipsOrPike,
    this.dips1,
    this.dips2,
    this.dips2Negatives,
    this.dips2NegativesFinal,
    this.pike1,
    this.pike2,
    this.pike2Negatives,
    this.pike2NegativesFinal,
    this.squatOrDeadlift,
    this.squat1,
    this.squat2,
    this.squat3,
    this.squat1Weight,
    this.squat2Weight,
    this.deadlift1,
    this.deadlift2,
    this.deadlift2Negatives,
    this.deadlift1Weight,
    this.deadlift2Weight,
    this.backExtension,
    this.legRaises,
    this.qlExtension,
    this.backExtension2,
    this.legRaises2,
    this.qlExtension2,
    this.notes,
  }) {
    this.id = id ?? DateTime.now();
    this.date = date ?? DateTime.now();
  }

  // Helper method to get the max reps for Set 1 based on workout type
  int? getMaxRepsSet1() {
    switch (type) {
      case 'pull':
        return pullups1;
      case 'push':
        return dipsOrPike == 'dips' ? dips1 : pike1;
      case 'legs':
        return squatOrDeadlift == 'squat' ? squat1 : deadlift1;
      default:
        return null;
    }
  }

  // Helper method to get the exercise name
  String getExerciseName() {
    switch (type) {
      case 'pull':
        return 'Pull-ups';
      case 'push':
        return dipsOrPike == 'dips' ? 'Dips' : 'Pike Push-ups';
      case 'legs':
        return squatOrDeadlift == 'squat' ? 'Squats' : 'Deadlifts';
      default:
        return 'Unknown';
    }
  }
}
