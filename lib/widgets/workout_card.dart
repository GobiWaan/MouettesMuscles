import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onDelete;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onDelete,
  });

  Color get _color {
    switch (workout.type) {
      case 'pull':
        return const Color(0xFF2563eb);
      case 'push':
        return const Color(0xFFdc2626);
      case 'legs':
        return const Color(0xFF16a34a);
      default:
        return Colors.blue;
    }
  }

  IconData get _icon {
    switch (workout.type) {
      case 'pull':
        return Icons.fitness_center;
      case 'push':
        return Icons.accessibility_new;
      case 'legs':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }

  String get _title {
    switch (workout.type) {
      case 'pull':
        return 'TIRAGE (Pull)';
      case 'push':
        return 'POUSSÉE (Push)';
      case 'legs':
        return 'JAMBES (Legs)';
      default:
        return 'Workout';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_icon, color: _color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _color,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy', 'fr_CA').format(workout.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(context),
                      color: Colors.red,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStat('Exercice', workout.getExerciseName()),
          ),
          Expanded(
            child: _buildStat('Set 1', '${workout.getMaxRepsSet1() ?? 0} reps'),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(_icon, color: _color, size: 32),
                const SizedBox(width: 12),
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE dd MMMM yyyy', 'fr_CA').format(workout.date),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 32),
            _buildDetailedStats(),
            if (workout.notes != null && workout.notes!.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(workout.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    final List<Widget> stats = [];

    if (workout.type == 'pull') {
      if (workout.pullups1 != null) stats.add(_detailRow('Pull-ups Set 1', '${workout.pullups1}'));
      if (workout.pullups2 != null) stats.add(_detailRow('Pull-ups Set 2', '${workout.pullups2}'));
      if (workout.pullups2Negatives != null) stats.add(_detailRow('Pull-ups Négatives', '${workout.pullups2Negatives}'));
      if (workout.pullups2NegativesFinal != null) stats.add(_detailRow('Pull-ups Négatives finales', '${workout.pullups2NegativesFinal}'));
      if (workout.bicepsCurls != null) stats.add(_detailRow('Biceps Curls', '${workout.bicepsCurls}'));
      if (workout.bicepsCurlsNegatives != null) stats.add(_detailRow('Biceps Curls Négatives', '${workout.bicepsCurlsNegatives}'));
      if (workout.backExtension != null) stats.add(_detailRow('Extension dorsale Set 1', '${workout.backExtension}'));
      if (workout.backExtension2 != null) stats.add(_detailRow('Extension dorsale Set 2', '${workout.backExtension2}'));
    } else if (workout.type == 'push') {
      // Pike Push-ups first
      if (workout.pike1 != null) stats.add(_detailRow('Pike Set 1', '${workout.pike1}'));
      if (workout.pike2 != null) stats.add(_detailRow('Pike Set 2', '${workout.pike2}'));
      if (workout.pike2Negatives != null) stats.add(_detailRow('Pike Négatives', '${workout.pike2Negatives}'));
      if (workout.pike2NegativesFinal != null) stats.add(_detailRow('Pike Négatives finales', '${workout.pike2NegativesFinal}'));
      // Dips second
      if (workout.dips1 != null) stats.add(_detailRow('Dips Set 1', '${workout.dips1}'));
      if (workout.dips2 != null) stats.add(_detailRow('Dips Set 2', '${workout.dips2}'));
      if (workout.dips2Negatives != null) stats.add(_detailRow('Dips Négatives', '${workout.dips2Negatives}'));
      if (workout.dips2NegativesFinal != null) stats.add(_detailRow('Dips Négatives finales', '${workout.dips2NegativesFinal}'));
      if (workout.legRaises != null) stats.add(_detailRow('Levées de jambes Set 1', '${workout.legRaises}'));
      if (workout.legRaises2 != null) stats.add(_detailRow('Levées de jambes Set 2', '${workout.legRaises2}'));
    } else if (workout.type == 'legs') {
      if (workout.squatOrDeadlift == 'squat') {
        if (workout.squat1 != null) {
          stats.add(_detailRowWithWeight('Squats Set 1', workout.squat1!, workout.squat1Weight));
        }
        if (workout.squat2 != null) {
          stats.add(_detailRowWithWeight('Squats Set 2', workout.squat2!, workout.squat2Weight));
        }
        if (workout.squat3 != null) {
          stats.add(_detailRow('Squats Set 3 (poids de corps)', '${workout.squat3}'));
        }
      } else {
        if (workout.deadlift1 != null) {
          stats.add(_detailRowWithWeight('Deadlifts Set 1', workout.deadlift1!, workout.deadlift1Weight));
        }
        if (workout.deadlift2 != null) {
          stats.add(_detailRowWithWeight('Deadlifts Set 2', workout.deadlift2!, workout.deadlift2Weight));
        }
      }
      if (workout.qlExtension != null) stats.add(_detailRow('Extension QL Set 1', '${workout.qlExtension}'));
      if (workout.qlExtension2 != null) stats.add(_detailRow('Extension QL Set 2', '${workout.qlExtension2}'));
    }

    return Column(children: stats);
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _detailRowWithWeight(String label, int reps, double? weight) {
    final String value = weight != null
        ? '$reps reps @ ${weight.toStringAsFixed(1)} lbs'
        : '$reps reps';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cet entraînement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
