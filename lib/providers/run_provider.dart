import 'package:flutter/foundation.dart';
import '../models/run.dart';
import '../services/hive_service.dart';

class RunProvider extends ChangeNotifier {
  List<Run> _runs = [];

  List<Run> get runs => _runs;

  RunProvider() {
    loadRuns();
  }

  void loadRuns() {
    _runs = HiveService.getAllRuns();
    notifyListeners();
  }

  Future<void> addRun(Run run) async {
    await HiveService.addRun(run);
    loadRuns();
  }

  Future<void> deleteRun(String key) async {
    await HiveService.deleteRun(key);
    loadRuns();
  }

  // Get total runs count
  int get totalRunCount => _runs.length;

  // Get average time per run
  double get averageTimePerRun {
    if (_runs.isEmpty) return 0;
    final total = _runs.map((r) => r.totalTime).reduce((a, b) => a + b);
    return total / _runs.length;
  }

  // Get runs by week
  List<Run> getRunsByWeek(int week) {
    return _runs.where((r) => r.week == week).toList();
  }

  // Get progression by week (count of runs per week)
  Map<int, int> getProgressionByWeek() {
    final progression = <int, int>{};
    for (var run in _runs) {
      progression[run.week] = (progression[run.week] ?? 0) + 1;
    }
    return progression;
  }

  // Get last N runs
  List<Run> getLastNRuns(int n) {
    return _runs.take(n).toList();
  }

  // Get total cycles count (ALL TIME)
  int get totalCyclesCount {
    if (_runs.isEmpty) return 0;
    return _runs.map((r) => r.cycles).reduce((a, b) => a + b);
  }
}
