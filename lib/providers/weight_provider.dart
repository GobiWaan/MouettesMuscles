import 'package:flutter/foundation.dart';
import '../models/weight.dart';
import '../services/hive_service.dart';

class WeightProvider extends ChangeNotifier {
  List<Weight> _weights = [];

  List<Weight> get weights => _weights;

  WeightProvider() {
    loadWeights();
  }

  void loadWeights() {
    _weights = HiveService.getAllWeights();
    notifyListeners();
  }

  Future<void> addWeight(Weight weight) async {
    await HiveService.addWeight(weight);
    loadWeights();
  }

  Future<void> deleteWeight(String key) async {
    await HiveService.deleteWeight(key);
    loadWeights();
  }

  // Get current weight (most recent)
  double? get currentWeight {
    if (_weights.isEmpty) return null;
    return _weights.first.weightLbs;
  }

  // Get starting weight (oldest)
  double? get startingWeight {
    if (_weights.isEmpty) return null;
    return _weights.last.weightLbs;
  }

  // Get total weight change
  double? get totalWeightChange {
    if (_weights.isEmpty || _weights.length < 2) return null;
    return currentWeight! - startingWeight!;
  }

  // Get weights for last N days
  List<Weight> getWeightsForLastNDays(int days) {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));
    return _weights.where((w) => w.date.isAfter(cutoffDate)).toList();
  }

  // Get average weight for a period
  double? getAverageWeight(int days) {
    final filtered = getWeightsForLastNDays(days);
    if (filtered.isEmpty) return null;
    final total = filtered.map((w) => w.weightLbs).reduce((a, b) => a + b);
    return total / filtered.length;
  }

  // Calculate moving average (7-day)
  List<double> getMovingAverage(int windowSize) {
    if (_weights.length < windowSize) return [];

    final sortedWeights = List<Weight>.from(_weights)
      ..sort((a, b) => a.date.compareTo(b.date));

    final movingAverages = <double>[];
    for (int i = windowSize - 1; i < sortedWeights.length; i++) {
      double sum = 0;
      for (int j = 0; j < windowSize; j++) {
        sum += sortedWeights[i - j].weightLbs;
      }
      movingAverages.add(sum / windowSize);
    }
    return movingAverages;
  }

  // Get weight trend (positive = gaining, negative = losing)
  String getWeightTrend() {
    if (_weights.length < 2) return 'N/A';
    final change = totalWeightChange!;
    if (change > 0) return '+${change.toStringAsFixed(1)} lbs';
    return '${change.toStringAsFixed(1)} lbs';
  }

  // Calculate weekly trend (average change per week over last 4 weeks)
  double? getWeeklyTrend() {
    final fourWeeksAgo = DateTime.now().subtract(const Duration(days: 28));
    final recentWeights = _weights
        .where((w) => w.date.isAfter(fourWeeksAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (recentWeights.length < 2) return null;

    // Group by week
    final weeklyAverages = <DateTime, List<double>>{};
    for (var weight in recentWeights) {
      final weekStart = _getWeekStart(weight.date);
      if (!weeklyAverages.containsKey(weekStart)) {
        weeklyAverages[weekStart] = [];
      }
      weeklyAverages[weekStart]!.add(weight.weightLbs);
    }

    // Need at least 2 weeks to calculate trend
    if (weeklyAverages.length < 2) return null;

    // Calculate average for each week
    final weeks = weeklyAverages.keys.toList()..sort();
    final averages = weeks.map((week) {
      final weights = weeklyAverages[week]!;
      return weights.reduce((a, b) => a + b) / weights.length;
    }).toList();

    // Calculate average change per week
    double totalChange = 0;
    for (int i = 1; i < averages.length; i++) {
      totalChange += (averages[i] - averages[i - 1]);
    }
    return totalChange / (averages.length - 1);
  }

  String getWeeklyTrendDisplay() {
    final trend = getWeeklyTrend();
    if (trend == null) return 'N/A';
    final sign = trend > 0 ? '+' : '';
    return '$sign${trend.toStringAsFixed(2)} lbs/sem';
  }

  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = (date.weekday - 1) % 7;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromMonday));
  }

  // Total weight entries
  int get totalWeightEntries => _weights.length;
}
