import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../providers/run_provider.dart';
import '../providers/weight_provider.dart';
import '../widgets/weight_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWorkoutStats(context),
          const SizedBox(height: 16),
          _buildRunStats(context),
          const SizedBox(height: 16),
          _buildWeightStats(context),
        ],
      ),
    );
  }

  Widget _buildWorkoutStats(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'Force',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildStatRow('Total entraînements', '${provider.totalWorkoutCount}'),
                const SizedBox(height: 16),
                const Text(
                  'Records personnels (Set 1)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPRRow(
                  'Pull-ups',
                  provider.getPullupsPR(),
                  const Color(0xFF2563eb),
                ),
                _buildPRRow(
                  'Dips',
                  provider.getDipsPR(),
                  const Color(0xFFdc2626),
                ),
                _buildPRRow(
                  'Pike Push-ups',
                  provider.getPikePR(),
                  const Color(0xFFdc2626),
                ),
                _buildPRRow(
                  'Squats',
                  provider.getSquatPR(),
                  const Color(0xFF16a34a),
                ),
                _buildPRRow(
                  'Deadlifts',
                  provider.getDeadliftPR(),
                  const Color(0xFF16a34a),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reps totales (ALL TIME)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTotalRepsRow('Pull-ups', provider.getTotalReps('pullups')),
                _buildTotalRepsRow('Biceps Curls', provider.getTotalReps('bicepsCurls')),
                _buildTotalRepsRow('Dips', provider.getTotalReps('dips')),
                _buildTotalRepsRow('Pike Push-ups', provider.getTotalReps('pike')),
                _buildTotalRepsRow('Squats', provider.getTotalReps('squats')),
                _buildTotalRepsRow('Deadlifts', provider.getTotalReps('deadlifts')),
                _buildTotalRepsRow('Extension dorsale', provider.getTotalReps('backExtension')),
                _buildTotalRepsRow('Levées de jambes', provider.getTotalReps('legRaises')),
                _buildTotalRepsRow('Extension QL', provider.getTotalReps('qlExtension')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRunStats(BuildContext context) {
    return Consumer<RunProvider>(
      builder: (context, provider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_walk, color: Colors.purple[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'Course',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildStatRow('Total courses', '${provider.totalRunCount}'),
                _buildStatRow('Total cycles', '${provider.totalCyclesCount}'),
                _buildStatRow(
                  'Temps moyen',
                  provider.totalRunCount > 0
                      ? '${provider.averageTimePerRun.toStringAsFixed(1)} min'
                      : 'N/A',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Progression par semaine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildWeekProgression(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightStats(BuildContext context) {
    return Consumer<WeightProvider>(
      builder: (context, provider, _) {
        if (provider.weights.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.monitor_weight, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Poids',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Aucune donnée de poids'),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.monitor_weight, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'Poids',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildWeightCard(
                        'Poids actuel',
                        '${provider.currentWeight!.toStringAsFixed(1)} lbs',
                        const Color(0xFFf59e0b),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (provider.totalWeightChange != null)
                      Expanded(
                        child: _buildWeightCard(
                          'Changement',
                          provider.getWeightTrend(),
                          provider.totalWeightChange! > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildWeightCard(
                        'Moyenne 7 jours',
                        provider.getAverageWeight(7) != null
                            ? '${provider.getAverageWeight(7)!.toStringAsFixed(1)} lbs'
                            : 'N/A',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildWeightCard(
                        'Tendance (4 sem)',
                        provider.getWeeklyTrendDisplay(),
                        _getTrendColor(provider.getWeeklyTrend()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                WeightChart(
                  weights: provider.weights,
                  daysToShow: 30,
                ),
                const SizedBox(height: 12),
                WeightChart(
                  weights: provider.weights,
                  showAllTime: true,
                  useWeeklyAverage: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPRRow(String exercise, int? pr, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(exercise),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              pr != null ? '$pr reps' : 'N/A',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRepsRow(String exercise, int totalReps) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(exercise),
          Text(
            '$totalReps reps',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekProgression(RunProvider provider) {
    final progression = provider.getProgressionByWeek();
    if (progression.isEmpty) {
      return [const Text('Aucune donnée')];
    }

    return [1, 3, 5, 7].map((week) {
      final count = progression[week] ?? 0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Semaine $week-${week + 1}'),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: count / 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9333ea)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getTrendColor(double? trend) {
    if (trend == null) return Colors.grey;
    if (trend > 0) return Colors.red; // Gaining weight
    if (trend < 0) return Colors.green; // Losing weight
    return Colors.grey; // No change
  }

  Widget _buildWeightCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
