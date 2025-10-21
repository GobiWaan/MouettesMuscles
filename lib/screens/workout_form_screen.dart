import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../services/rest_timer_service.dart';
import '../widgets/rest_timer_widget.dart';

class WorkoutFormScreen extends StatefulWidget {
  final String workoutType;

  const WorkoutFormScreen({super.key, required this.workoutType});

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  // Pull fields
  final TextEditingController _pullups1Controller = TextEditingController();
  final TextEditingController _pullups2Controller = TextEditingController();
  final TextEditingController _pullups2NegativesController = TextEditingController();
  final TextEditingController _pullups2NegativesFinalController = TextEditingController();
  final TextEditingController _bicepsCurlsController = TextEditingController();
  final TextEditingController _bicepsCurlsNegativesController = TextEditingController();

  // Push fields (no longer need choice)
  final TextEditingController _dips1Controller = TextEditingController();
  final TextEditingController _dips2Controller = TextEditingController();
  final TextEditingController _dips2NegativesController = TextEditingController();
  final TextEditingController _dips2NegativesFinalController = TextEditingController();
  final TextEditingController _pike1Controller = TextEditingController();
  final TextEditingController _pike2Controller = TextEditingController();
  final TextEditingController _pike2NegativesController = TextEditingController();
  final TextEditingController _pike2NegativesFinalController = TextEditingController();

  // Legs fields
  String _legsExercise = 'squat';
  final TextEditingController _squat1Controller = TextEditingController();
  final TextEditingController _squat2Controller = TextEditingController();
  final TextEditingController _squat3Controller = TextEditingController(); // Bodyweight set
  final TextEditingController _squat1WeightController = TextEditingController();
  final TextEditingController _squat2WeightController = TextEditingController();
  final TextEditingController _deadlift1Controller = TextEditingController();
  final TextEditingController _deadlift2Controller = TextEditingController();
  final TextEditingController _deadlift1WeightController = TextEditingController();
  final TextEditingController _deadlift2WeightController = TextEditingController();

  // Accessory exercise fields
  final TextEditingController _backExtensionController = TextEditingController(); // Pull - Set 1
  final TextEditingController _backExtension2Controller = TextEditingController(); // Pull - Set 2
  final TextEditingController _legRaisesController = TextEditingController(); // Push - Set 1
  final TextEditingController _legRaises2Controller = TextEditingController(); // Push - Set 2
  final TextEditingController _qlExtensionController = TextEditingController(); // Legs - Set 1
  final TextEditingController _qlExtension2Controller = TextEditingController(); // Legs - Set 2

  final TextEditingController _notesController = TextEditingController();

  String get _title {
    switch (widget.workoutType) {
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
  void initState() {
    super.initState();
    if (widget.workoutType == 'legs') {
      // Automatically determine squat or deadlift based on last legs workout
      final provider = Provider.of<WorkoutProvider>(context, listen: false);
      final lastLegsWorkout = provider.getWorkoutsByType('legs').firstOrNull;

      if (lastLegsWorkout != null && lastLegsWorkout.squatOrDeadlift == 'squat') {
        _legsExercise = 'deadlift';
      } else {
        _legsExercise = 'squat';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDatePicker(color),
            const SizedBox(height: 24),
            if (widget.workoutType == 'pull') ..._buildPullFields(color),
            if (widget.workoutType == 'push') ..._buildPushFields(color),
            if (widget.workoutType == 'legs') ..._buildLegsFields(color),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 24),
            _buildSaveButton(color),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: Consumer<RestTimerService>(
        builder: (context, timerService, child) {
          final isActive = timerService.isRunning || timerService.remainingSeconds < RestTimerService.defaultDuration;

          return FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const RestTimerWidget(),
              );
            },
            icon: Icon(timerService.isRunning ? Icons.timer : Icons.timer_outlined),
            label: Text(isActive ? _formatTime(timerService.remainingSeconds) : 'Repos'),
            backgroundColor: color,
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(Color color) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: color),
        title: const Text('Date'),
        subtitle: Text(DateFormat('dd MMMM yyyy', 'fr_CA').format(_selectedDate)),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() => _selectedDate = date);
          }
        },
      ),
    );
  }

  List<Widget> _buildPullFields(Color color) {
    return [
      Text(
        'Pull-ups',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 (normal)', _pullups1Controller),
      _buildNumberField('Set 2 (avant négatives)', _pullups2Controller),
      _buildNumberField('Set 2 - Négatives', _pullups2NegativesController),
      _buildNumberField('Set 2 - Négatives finales', _pullups2NegativesFinalController),
      const SizedBox(height: 16),
      const Text(
        'Biceps Curls',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Reps normales', _bicepsCurlsController),
      _buildNumberField('Négatives', _bicepsCurlsNegativesController),
      const SizedBox(height: 16),
      const Text(
        'Extension dorsale',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 - Reps jusqu\'à l\'échec', _backExtensionController),
      const SizedBox(height: 8),
      _buildNumberField('Set 2 - Reps jusqu\'à l\'échec', _backExtension2Controller),
    ];
  }

  List<Widget> _buildPushFields(Color color) {
    return [
      Text(
        'Pike Push-ups',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 (normal)', _pike1Controller),
      _buildNumberField('Set 2 (avant négatives)', _pike2Controller),
      _buildNumberField('Set 2 - Négatives', _pike2NegativesController),
      _buildNumberField('Set 2 - Négatives finales', _pike2NegativesFinalController),
      const SizedBox(height: 16),
      Text(
        'Dips',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 (normal)', _dips1Controller),
      _buildNumberField('Set 2 (avant négatives)', _dips2Controller),
      _buildNumberField('Set 2 - Négatives', _dips2NegativesController),
      _buildNumberField('Set 2 - Négatives finales', _dips2NegativesFinalController),
      const SizedBox(height: 16),
      const Text(
        'Levées de jambes (abdos)',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 - Reps jusqu\'à l\'échec', _legRaisesController),
      const SizedBox(height: 8),
      _buildNumberField('Set 2 - Reps jusqu\'à l\'échec', _legRaises2Controller),
    ];
  }

  List<Widget> _buildLegsFields(Color color) {
    return [
      if (_legsExercise == 'squat') ...[
        Text(
          'Squats',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 12),
        _buildWeightedSetField('Set 1', _squat1Controller, _squat1WeightController),
        const SizedBox(height: 8),
        _buildWeightedSetField('Set 2', _squat2Controller, _squat2WeightController),
        const SizedBox(height: 8),
        _buildNumberField('Set 3 (poids de corps)', _squat3Controller),
      ] else ...[
        Text(
          'Deadlifts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 12),
        _buildWeightedSetField('Set 1', _deadlift1Controller, _deadlift1WeightController),
        const SizedBox(height: 8),
        _buildWeightedSetField('Set 2', _deadlift2Controller, _deadlift2WeightController),
      ],
      const SizedBox(height: 16),
      const Text(
        'Extension QL',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildNumberField('Set 1 - Reps jusqu\'à l\'échec', _qlExtensionController),
      const SizedBox(height: 8),
      _buildNumberField('Set 2 - Reps jusqu\'à l\'échec', _qlExtension2Controller),
    ];
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildWeightedSetField(String label, TextEditingController repsController, TextEditingController weightController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: repsController,
              decoration: InputDecoration(
                labelText: '$label - Reps',
                border: const OutlineInputBorder(),
                filled: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'lbs',
                border: const OutlineInputBorder(),
                filled: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (optionnel)',
        border: const OutlineInputBorder(),
        filled: true,
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton(Color color) {
    return ElevatedButton(
      onPressed: _saveWorkout,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Enregistrer',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        date: _selectedDate,
        type: widget.workoutType,
        pullups1: _parseInt(_pullups1Controller.text),
        pullups2: _parseInt(_pullups2Controller.text),
        pullups2Negatives: _parseInt(_pullups2NegativesController.text),
        pullups2NegativesFinal: _parseInt(_pullups2NegativesFinalController.text),
        bicepsCurls: _parseInt(_bicepsCurlsController.text),
        bicepsCurlsNegatives: _parseInt(_bicepsCurlsNegativesController.text),
        dipsOrPike: null, // No longer used
        dips1: _parseInt(_dips1Controller.text),
        dips2: _parseInt(_dips2Controller.text),
        dips2Negatives: _parseInt(_dips2NegativesController.text),
        dips2NegativesFinal: _parseInt(_dips2NegativesFinalController.text),
        pike1: _parseInt(_pike1Controller.text),
        pike2: _parseInt(_pike2Controller.text),
        pike2Negatives: _parseInt(_pike2NegativesController.text),
        pike2NegativesFinal: _parseInt(_pike2NegativesFinalController.text),
        squatOrDeadlift: widget.workoutType == 'legs' ? _legsExercise : null,
        squat1: _parseInt(_squat1Controller.text),
        squat2: _parseInt(_squat2Controller.text),
        squat3: _parseInt(_squat3Controller.text),
        squat1Weight: _parseDouble(_squat1WeightController.text),
        squat2Weight: _parseDouble(_squat2WeightController.text),
        deadlift1: _parseInt(_deadlift1Controller.text),
        deadlift2: _parseInt(_deadlift2Controller.text),
        deadlift2Negatives: null, // No longer used
        deadlift1Weight: _parseDouble(_deadlift1WeightController.text),
        deadlift2Weight: _parseDouble(_deadlift2WeightController.text),
        backExtension: _parseInt(_backExtensionController.text),
        legRaises: _parseInt(_legRaisesController.text),
        qlExtension: _parseInt(_qlExtensionController.text),
        backExtension2: _parseInt(_backExtension2Controller.text),
        legRaises2: _parseInt(_legRaises2Controller.text),
        qlExtension2: _parseInt(_qlExtension2Controller.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      context.read<WorkoutProvider>().addWorkout(workout);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excellent travail!')),
      );

      Navigator.pop(context);
    }
  }

  int? _parseInt(String text) {
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  double? _parseDouble(String text) {
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pullups1Controller.dispose();
    _pullups2Controller.dispose();
    _pullups2NegativesController.dispose();
    _pullups2NegativesFinalController.dispose();
    _bicepsCurlsController.dispose();
    _bicepsCurlsNegativesController.dispose();
    _dips1Controller.dispose();
    _dips2Controller.dispose();
    _dips2NegativesController.dispose();
    _dips2NegativesFinalController.dispose();
    _pike1Controller.dispose();
    _pike2Controller.dispose();
    _pike2NegativesController.dispose();
    _pike2NegativesFinalController.dispose();
    _squat1Controller.dispose();
    _squat2Controller.dispose();
    _squat3Controller.dispose();
    _squat1WeightController.dispose();
    _squat2WeightController.dispose();
    _deadlift1Controller.dispose();
    _deadlift2Controller.dispose();
    _deadlift1WeightController.dispose();
    _deadlift2WeightController.dispose();
    _backExtensionController.dispose();
    _backExtension2Controller.dispose();
    _legRaisesController.dispose();
    _legRaises2Controller.dispose();
    _qlExtensionController.dispose();
    _qlExtension2Controller.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
