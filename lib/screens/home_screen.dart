import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../providers/run_provider.dart';
import '../providers/weight_provider.dart';
import '../services/workout_cycle_service.dart';
import 'workout_form_screen.dart';
import 'run_form_screen.dart';
import 'weight_form_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HistoryScreen(),
    const StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'PetitSeagulDor.png',
              height: 40,
            ),
            const SizedBox(width: 12),
            const Text('Mouette Musclé'),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer3<WorkoutProvider, RunProvider, WeightProvider>(
        builder: (context, workoutProvider, runProvider, weightProvider, _) {
          final nextWorkout = WorkoutCycleService.getNextWorkout(
            workoutProvider.workouts,
            runProvider.runs,
          );
          final cyclePosition = WorkoutCycleService.getCyclePosition(nextWorkout);
          final recentCycle = WorkoutCycleService.getRecentCycleStatus(
            workoutProvider.workouts,
            runProvider.runs,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Today's Workout Card
              _buildTodayWorkoutCard(context, nextWorkout, cyclePosition),
              const SizedBox(height: 24),

              // Recent cycle progress
              _buildRecentCycleProgress(context, recentCycle),
              const SizedBox(height: 24),

              // Quick actions
              const Text(
                'Actions rapides',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickActions(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTodayWorkoutCard(BuildContext context, String nextWorkout, int cyclePosition) {
    final color = Theme.of(context).colorScheme.primary;
    final displayName = WorkoutCycleService.getWorkoutDisplayName(nextWorkout);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _navigateToWorkout(context, nextWorkout),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'JOUR $cyclePosition/4',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'WORKOUT DU JOUR',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      nextWorkout == 'run' ? Icons.directions_walk : Icons.fitness_center,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Appuie pour commencer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildRecentCycleProgress(BuildContext context, List<Map<String, dynamic>> recentCycle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Derniers workouts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recentCycle.isEmpty)
              const Text('Aucun workout enregistré')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recentCycle.map((activity) {
                  final type = activity['type'] as String;
                  final color = Theme.of(context).colorScheme.primary;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type == 'run' ? Icons.directions_walk : Icons.fitness_center,
                          color: color,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          WorkoutCycleService.getWorkoutDisplayName(type),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSmallActionCard(
                context,
                title: 'Poids',
                icon: Icons.monitor_weight,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeightFormScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallActionCard(
                context,
                title: 'Historique',
                icon: Icons.history,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  // Navigate to history tab
                  final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeScreenState?.setState(() {
                    homeScreenState._currentIndex = 1;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSmallActionCard(
                context,
                title: 'Stats',
                icon: Icons.analytics,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  // Navigate to stats tab
                  final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeScreenState?.setState(() {
                    homeScreenState._currentIndex = 2;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallActionCard(
                context,
                title: 'Autre workout',
                icon: Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => _showWorkoutPicker(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToWorkout(BuildContext context, String type) {
    if (type == 'run') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RunFormScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutFormScreen(workoutType: type),
        ),
      );
    }
  }

  void _showWorkoutPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisir un workout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWorkoutPickerItem(context, 'Pull', 'pull', Theme.of(context).colorScheme.primary),
            _buildWorkoutPickerItem(context, 'Push', 'push', Theme.of(context).colorScheme.primary),
            _buildWorkoutPickerItem(context, 'Legs', 'legs', Theme.of(context).colorScheme.primary),
            _buildWorkoutPickerItem(context, 'Course', 'run', Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutPickerItem(BuildContext context, String title, String type, Color color) {
    return ListTile(
      leading: Icon(
        type == 'run' ? Icons.directions_walk : Icons.fitness_center,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _navigateToWorkout(context, type);
      },
    );
  }
}
