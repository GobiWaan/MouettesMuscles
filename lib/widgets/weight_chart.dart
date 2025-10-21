import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/weight.dart';

class WeightChart extends StatelessWidget {
  final List<Weight> weights;
  final int daysToShow;
  final bool showAllTime;
  final bool useWeeklyAverage;

  const WeightChart({
    super.key,
    required this.weights,
    this.daysToShow = 30,
    this.showAllTime = false,
    this.useWeeklyAverage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return const Center(
        child: Text('Aucune donnée à afficher'),
      );
    }

    final sortedWeights = List<Weight>.from(weights)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Filter weights based on showAllTime flag
    final List<Weight> filteredWeights;
    if (showAllTime) {
      filteredWeights = sortedWeights;
    } else {
      final now = DateTime.now();
      final cutoffDate = now.subtract(Duration(days: daysToShow));
      filteredWeights = sortedWeights
          .where((w) => w.date.isAfter(cutoffDate))
          .toList();
    }

    if (filteredWeights.isEmpty) {
      return const Center(
        child: Text('Aucune donnée pour cette période'),
      );
    }

    // Calculate weekly averages if needed
    final List<Weight> displayWeights = useWeeklyAverage && showAllTime
        ? _calculateWeeklyAverages(filteredWeights)
        : filteredWeights;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getChartTitle(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                _buildChartData(displayWeights),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    if (showAllTime) {
      return useWeeklyAverage
          ? 'Évolution du poids (moyennes hebdomadaires)'
          : 'Évolution du poids (tout)';
    }
    return 'Évolution du poids ($daysToShow derniers jours)';
  }

  List<Weight> _calculateWeeklyAverages(List<Weight> weights) {
    if (weights.isEmpty) return [];

    final weeklyData = <DateTime, List<double>>{};

    for (var weight in weights) {
      // Get the start of the week (Monday)
      final weekStart = _getWeekStart(weight.date);

      if (!weeklyData.containsKey(weekStart)) {
        weeklyData[weekStart] = [];
      }
      weeklyData[weekStart]!.add(weight.weightLbs);
    }

    // Calculate averages and create Weight objects
    final weeklyAverages = <Weight>[];
    weeklyData.forEach((weekStart, weightList) {
      final average = weightList.reduce((a, b) => a + b) / weightList.length;
      weeklyAverages.add(Weight(
        date: weekStart,
        weightLbs: average,
      ));
    });

    weeklyAverages.sort((a, b) => a.date.compareTo(b.date));
    return weeklyAverages;
  }

  DateTime _getWeekStart(DateTime date) {
    // Get Monday of the week
    final daysFromMonday = (date.weekday - 1) % 7;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysFromMonday));
  }

  LineChartData _buildChartData(List<Weight> weights) {
    final spots = <FlSpot>[];
    final minDate = weights.first.date;

    for (var i = 0; i < weights.length; i++) {
      final weight = weights[i];
      final daysSinceStart = weight.date.difference(minDate).inDays.toDouble();
      spots.add(FlSpot(daysSinceStart, weight.weightLbs));
    }

    // Calculate min and max for better scaling
    final minWeight = weights.map((w) => w.weightLbs).reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.map((w) => w.weightLbs).reduce((a, b) => a > b ? a : b);
    final range = maxWeight - minWeight;
    final padding = range > 0 ? range * 0.1 : 5.0;

    // Calculate appropriate interval for bottom axis based on data range
    final totalDays = weights.last.date.difference(weights.first.date).inDays;
    final bottomInterval = _calculateBottomInterval(totalDays);
    final dateFormat = totalDays > 90 ? 'MMM yy' : 'dd MMM';

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            reservedSize: 45,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()} lbs',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: bottomInterval,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final date = minDate.add(Duration(days: value.toInt()));
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat(dateFormat).format(date),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      minY: minWeight - padding,
      maxY: maxWeight + padding,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFFf59e0b),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: !useWeeklyAverage || spots.length < 20,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFFf59e0b),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFFf59e0b).withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final date = minDate.add(Duration(days: spot.x.toInt()));
              final label = useWeeklyAverage
                  ? 'Semaine du ${DateFormat('dd MMM').format(date)}'
                  : DateFormat('dd MMM').format(date);
              return LineTooltipItem(
                '$label\n${spot.y.toStringAsFixed(1)} lbs',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  double _calculateBottomInterval(int totalDays) {
    if (totalDays <= 30) return 7.0;
    if (totalDays <= 90) return 14.0;
    if (totalDays <= 180) return 30.0;
    return 60.0;
  }
}
