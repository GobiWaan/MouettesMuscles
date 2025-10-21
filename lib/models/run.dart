import 'package:hive/hive.dart';

part 'run.g.dart';

@HiveType(typeId: 1)
class Run extends HiveObject {
  @HiveField(0)
  late DateTime id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late int week; // 1, 3, 5, or 7 (week of the program)

  @HiveField(3)
  late int runMinutes;

  @HiveField(4)
  late int walkMinutes;

  @HiveField(5)
  late int cycles;

  @HiveField(6)
  late int totalTime;

  @HiveField(7)
  late String feeling; // "excellent", "good", "hard", "veryhard"

  @HiveField(8)
  String? notes;

  Run({
    DateTime? id,
    DateTime? date,
    required this.week,
    required this.runMinutes,
    required this.walkMinutes,
    required this.cycles,
    int? totalTime,
    required this.feeling,
    this.notes,
  }) {
    this.id = id ?? DateTime.now();
    this.date = date ?? DateTime.now();
    this.totalTime = totalTime ?? calculateTotalTime();
  }

  // Calculate total time automatically
  int calculateTotalTime() {
    return (runMinutes + walkMinutes) * cycles;
  }

  // Get feeling emoji
  String getFeelingEmoji() {
    switch (feeling) {
      case 'excellent':
        return '😄';
      case 'good':
        return '😊';
      case 'hard':
        return '😓';
      case 'veryhard':
        return '😫';
      default:
        return '😐';
    }
  }

  // Get feeling label
  String getFeelingLabel() {
    switch (feeling) {
      case 'excellent':
        return 'Excellent';
      case 'good':
        return 'Bon';
      case 'hard':
        return 'Difficile';
      case 'veryhard':
        return 'Très difficile';
      default:
        return 'Inconnu';
    }
  }
}
