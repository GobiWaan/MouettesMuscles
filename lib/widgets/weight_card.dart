import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weight.dart';

class WeightCard extends StatelessWidget {
  final Weight weight;
  final Weight? previousWeight;
  final VoidCallback? onDelete;

  const WeightCard({
    super.key,
    required this.weight,
    this.previousWeight,
    this.onDelete,
  });

  final Color _color = const Color(0xFFf59e0b);

  @override
  Widget build(BuildContext context) {
    final double? change = previousWeight != null
        ? weight.weightLbs - previousWeight!.weightLbs
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.monitor_weight, color: _color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weight.weightLbs.toStringAsFixed(1)} lbs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _color,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy', 'fr_CA').format(weight.date),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (change != null)
                      Row(
                        children: [
                          Icon(
                            change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 14,
                            color: change > 0 ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} lbs',
                            style: TextStyle(
                              fontSize: 12,
                              color: change > 0 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final double? change = previousWeight != null
        ? weight.weightLbs - previousWeight!.weightLbs
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Icon(Icons.monitor_weight, color: _color, size: 32),
                const SizedBox(width: 12),
                Text(
                  'POIDS',
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
              DateFormat('EEEE dd MMMM yyyy', 'fr_CA').format(weight.date),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    '${weight.weightLbs.toStringAsFixed(1)} lbs',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _color,
                    ),
                  ),
                  Text(
                    '${weight.weightKg.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (change != null) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: change > 0
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        change > 0 ? Icons.trending_up : Icons.trending_down,
                        size: 20,
                        color: change > 0 ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} lbs',
                        style: TextStyle(
                          fontSize: 16,
                          color: change > 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' depuis la dernière pesée'),
                    ],
                  ),
                ),
              ),
            ],
            if (weight.notes != null && weight.notes!.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(weight.notes!),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cette pesée?'),
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
