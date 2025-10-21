import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rest_timer_service.dart';

class RestTimerWidget extends StatefulWidget {
  const RestTimerWidget({super.key});

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  RestTimerService? _timerService;

  @override
  void initState() {
    super.initState();
    // Listen for timer completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerService = context.read<RestTimerService>();
      _timerService!.addListener(_checkTimerCompletion);
    });
  }

  void _checkTimerCompletion() {
    if (!mounted || _timerService == null) return;
    if (_timerService!.remainingSeconds == 0 && !_timerService!.isRunning) {
      // Only show dialog if we were previously running (completion just happened)
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Repos terminé!'),
        content: const Text('C\'est l\'heure du prochain set!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<RestTimerService>().resetTimer();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timerService?.removeListener(_checkTimerCompletion);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestTimerService>(
      builder: (context, timerService, child) {
        final progress = timerService.remainingSeconds / RestTimerService.defaultDuration;
        final color = timerService.remainingSeconds <= 10
            ? Colors.red
            : timerService.remainingSeconds <= 30
                ? Colors.orange
                : Colors.green;

        return _buildTimerContent(context, timerService, progress, color);
      },
    );
  }

  Widget _buildTimerContent(BuildContext context, RestTimerService timerService, double progress, Color color) {

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Text(
            'Temps de repos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Circular progress indicator with time
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(timerService.remainingSeconds),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      '/ ${formatTime(RestTimerService.defaultDuration)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset button
              IconButton.filled(
                onPressed: () => timerService.resetTimer(),
                icon: const Icon(Icons.restart_alt),
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[800],
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 24),

              // Start/Pause button
              IconButton.filled(
                onPressed: timerService.isRunning
                    ? () => timerService.pauseTimer()
                    : () => timerService.startTimer(),
                icon: Icon(timerService.isRunning ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                style: IconButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                ),
              ),
              const SizedBox(width: 24),

              // Add time button
              IconButton.filled(
                onPressed: () => timerService.addTime(30),
                icon: const Icon(Icons.add),
                iconSize: 32,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick action buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildQuickButton('1 min', 60),
              _buildQuickButton('2 min', 120),
              _buildQuickButton('3 min', 180),
              _buildQuickButton('5 min', 300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, int seconds) {
    return Consumer<RestTimerService>(
      builder: (context, timerService, child) {
        return OutlinedButton(
          onPressed: () => timerService.setTime(seconds),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: const Size(80, 52),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(label),
        );
      },
    );
  }
}
