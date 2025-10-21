import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/interval_timer_service.dart';

class IntervalTimerScreen extends StatelessWidget {
  const IntervalTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timerService = context.read<IntervalTimerService>();
        if (timerService.isRunning) {
          final shouldPop = await _showExitDialog(context);
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Timer d\'intervalles'),
          backgroundColor: const Color(0xFF9333ea),
          foregroundColor: Colors.white,
        ),
        body: Consumer<IntervalTimerService>(
          builder: (context, timerService, child) {
            if (timerService.isComplete) {
              return _buildCompleteView(context);
            }

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current phase indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: timerService.isRunPhase
                                ? Colors.red.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            timerService.currentPhaseLabel,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: timerService.isRunPhase
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Large countdown timer
                        Text(
                          timerService.formattedTime,
                          style: const TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Cycle indicator
                        Text(
                          'Cycle ${timerService.currentCycle}/${timerService.totalCycles}',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Total time remaining
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Temps total restant',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timerService.formattedTotalTimeRemaining,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Control buttons
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Reset button
                        _buildControlButton(
                          icon: Icons.refresh,
                          label: 'Recommencer',
                          onPressed: () {
                            timerService.reset();
                          },
                          color: Colors.orange,
                        ),
                        // Play/Pause button
                        _buildControlButton(
                          icon: timerService.isRunning
                              ? Icons.pause
                              : Icons.play_arrow,
                          label: timerService.isRunning ? 'Pause' : 'Démarrer',
                          onPressed: () {
                            if (timerService.isRunning) {
                              timerService.pause();
                            } else {
                              timerService.start();
                            }
                          },
                          color: timerService.isRunning
                              ? Colors.amber
                              : Colors.green,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(isPrimary ? 28 : 20),
            shape: const CircleBorder(),
            elevation: 8,
          ),
          child: Icon(icon, size: isPrimary ? 48 : 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 120,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            'Entraînement terminé!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333ea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
            ),
            child: const Text(
              'Retour',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter?'),
        content: const Text(
          'Le timer est en cours. Voulez-vous vraiment quitter?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }
}
