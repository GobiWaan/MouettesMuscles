import 'package:hive/hive.dart';

part 'weight.g.dart';

@HiveType(typeId: 2)
class Weight extends HiveObject {
  @HiveField(0)
  late DateTime id;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late double weightLbs;

  @HiveField(3)
  String? notes;

  Weight({
    DateTime? id,
    DateTime? date,
    required this.weightLbs,
    this.notes,
  }) {
    this.id = id ?? DateTime.now();
    this.date = date ?? DateTime.now();
  }

  // Convert to kg for display if needed
  double get weightKg => weightLbs * 0.453592;
}
