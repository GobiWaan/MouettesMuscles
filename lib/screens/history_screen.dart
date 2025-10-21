import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../providers/run_provider.dart';
import '../providers/weight_provider.dart';
import '../widgets/workout_card.dart';
import '../widgets/run_card.dart';
import '../widgets/weight_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tout'),
            Tab(text: 'Force'),
            Tab(text: 'Course'),
            Tab(text: 'Poids'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllHistory(),
          _buildWorkoutHistory(),
          _buildRunHistory(),
          _buildWeightHistory(),
        ],
      ),
    );
  }

  Widget _buildAllHistory() {
    return Consumer3<WorkoutProvider, RunProvider, WeightProvider>(
      builder: (context, workoutProvider, runProvider, weightProvider, _) {
        final allItems = <Map<String, dynamic>>[];

        // Add all workouts
        for (var workout in workoutProvider.workouts) {
          allItems.add({
            'type': 'workout',
            'date': workout.date,
            'data': workout,
          });
        }

        // Add all runs
        for (var run in runProvider.runs) {
          allItems.add({
            'type': 'run',
            'date': run.date,
            'data': run,
          });
        }

        // Add all weights
        for (var weight in weightProvider.weights) {
          allItems.add({
            'type': 'weight',
            'date': weight.date,
            'data': weight,
          });
        }

        // Sort by date
        allItems.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

        if (allItems.isEmpty) {
          return _buildEmptyState('Aucune donnée enregistrée');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: allItems.length,
          itemBuilder: (context, index) {
            final item = allItems[index];
            switch (item['type']) {
              case 'workout':
                return WorkoutCard(
                  workout: item['data'],
                  onDelete: () {
                    final key = item['data'].id.millisecondsSinceEpoch.toString();
                    workoutProvider.deleteWorkout(key);
                  },
                );
              case 'run':
                return RunCard(
                  run: item['data'],
                  onDelete: () {
                    final key = item['data'].id.millisecondsSinceEpoch.toString();
                    runProvider.deleteRun(key);
                  },
                );
              case 'weight':
                final weightIndex = weightProvider.weights.indexOf(item['data']);
                final previousWeight = weightIndex < weightProvider.weights.length - 1
                    ? weightProvider.weights[weightIndex + 1]
                    : null;
                return WeightCard(
                  weight: item['data'],
                  previousWeight: previousWeight,
                  onDelete: () {
                    final key = item['data'].id.millisecondsSinceEpoch.toString();
                    weightProvider.deleteWeight(key);
                  },
                );
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildWorkoutHistory() {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        if (provider.workouts.isEmpty) {
          return _buildEmptyState('Aucun entraînement enregistré');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.workouts.length,
          itemBuilder: (context, index) {
            final workout = provider.workouts[index];
            return WorkoutCard(
              workout: workout,
              onDelete: () {
                final key = workout.id.millisecondsSinceEpoch.toString();
                provider.deleteWorkout(key);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRunHistory() {
    return Consumer<RunProvider>(
      builder: (context, provider, _) {
        if (provider.runs.isEmpty) {
          return _buildEmptyState('Aucune course enregistrée');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.runs.length,
          itemBuilder: (context, index) {
            final run = provider.runs[index];
            return RunCard(
              run: run,
              onDelete: () {
                final key = run.id.millisecondsSinceEpoch.toString();
                provider.deleteRun(key);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildWeightHistory() {
    return Consumer<WeightProvider>(
      builder: (context, provider, _) {
        if (provider.weights.isEmpty) {
          return _buildEmptyState('Aucune pesée enregistrée');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.weights.length,
          itemBuilder: (context, index) {
            final weight = provider.weights[index];
            final previousWeight = index < provider.weights.length - 1
                ? provider.weights[index + 1]
                : null;
            return WeightCard(
              weight: weight,
              previousWeight: previousWeight,
              onDelete: () {
                final key = weight.id.millisecondsSinceEpoch.toString();
                provider.deleteWeight(key);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
