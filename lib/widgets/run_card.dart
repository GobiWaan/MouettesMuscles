import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/run.dart';

class RunCard extends StatelessWidget {
  final Run run;
  final VoidCallback? onDelete;

  const RunCard({
    super.key,
    required this.run,
    this.onDelete,
  });

  final Color _color = const Color(0xFF9333ea);

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
                    child: Icon(Icons.directions_walk, color: _color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COURSE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _color,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy', 'fr_CA').format(run.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    run.getFeelingEmoji(),
                    style: const TextStyle(fontSize: 24),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStat('Semaine', '${run.week}-${run.week + 1}'),
                    ),
                    Expanded(
                      child: _buildStat('Temps total', '${run.totalTime} min'),
                    ),
                    Expanded(
                      child: _buildStat('Cycles', '${run.cycles}x'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                Icon(Icons.directions_walk, color: _color, size: 32),
                const SizedBox(width: 12),
                Text(
                  'COURSE',
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
              DateFormat('EEEE dd MMMM yyyy', 'fr_CA').format(run.date),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 32),
            _detailRow('Programme', 'Semaine ${run.week}-${run.week + 1}'),
            _detailRow('Course', '${run.runMinutes} min'),
            _detailRow('Marche', '${run.walkMinutes} min'),
            _detailRow('Cycles', '${run.cycles}x'),
            _detailRow('Temps total', '${run.totalTime} min'),
            _detailRow('Sentiment', '${run.getFeelingEmoji()} ${run.getFeelingLabel()}'),
            if (run.notes != null && run.notes!.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(run.notes!),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer cette course?'),
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
