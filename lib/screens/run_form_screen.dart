import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/run.dart';
import '../providers/run_provider.dart';
import '../services/interval_timer_service.dart';
import 'interval_timer_screen.dart';

class RunFormScreen extends StatefulWidget {
  const RunFormScreen({super.key});

  @override
  State<RunFormScreen> createState() => _RunFormScreenState();
}

class _RunFormScreenState extends State<RunFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  int _selectedWeek = 1;
  String _selectedFeeling = 'good';

  final TextEditingController _runMinutesController = TextEditingController();
  final TextEditingController _walkMinutesController = TextEditingController();
  final TextEditingController _cyclesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final Color _color = const Color(0xFF9333ea);

  final Map<int, Map<String, dynamic>> _weekPrograms = {
    1: {'run': 1, 'walk': 2, 'cycles': 8},
    3: {'run': 2, 'walk': 2, 'cycles': 6},
    5: {'run': 5, 'walk': 2, 'cycles': 3},
    7: {'run': 8, 'walk': 1, 'cycles': 3},
  };

  @override
  void initState() {
    super.initState();
    _loadProgramDefaults();
  }

  void _loadProgramDefaults() {
    final program = _weekPrograms[_selectedWeek]!;
    _runMinutesController.text = program['run'].toString();
    _walkMinutesController.text = program['walk'].toString();
    _cyclesController.text = program['cycles'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COURSE (Couch to 5K)'),
        backgroundColor: _color,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildWeekSelector(),
            const SizedBox(height: 24),
            _buildProgramDetails(),
            const SizedBox(height: 24),
            _buildNumberField('Minutes de course', _runMinutesController, required: true),
            _buildNumberField('Minutes de marche', _walkMinutesController, required: true),
            _buildNumberField('Nombre de cycles', _cyclesController, required: true),
            const SizedBox(height: 24),
            _buildFeelingSelector(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 24),
            _buildStartTimerButton(),
            const SizedBox(height: 12),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: _color),
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

  Widget _buildWeekSelector() {
    return Card(
      color: _color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Semaine du programme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [1, 3, 5, 7].map((week) {
                return ChoiceChip(
                  label: Text('Semaine $week-${week + 1}'),
                  selected: _selectedWeek == week,
                  onSelected: (selected) {
                    setState(() {
                      _selectedWeek = week;
                      _loadProgramDefaults();
                    });
                  },
                  selectedColor: _color,
                  labelStyle: TextStyle(
                    color: _selectedWeek == week ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramDetails() {
    final program = _weekPrograms[_selectedWeek]!;
    final totalTime = (program['run'] + program['walk']) * program['cycles'];

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: _color),
                const SizedBox(width: 8),
                const Text(
                  'Programme suggéré',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Course : ${program['run']} minutes'),
            Text('Marche : ${program['walk']} minutes'),
            Text('Cycles : ${program['cycles']}x'),
            Text('Temps total : $totalTime minutes'),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller, {bool required = false}) {
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
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildFeelingSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comment c\'était?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _feelingChip('Excellent', 'excellent', '😄'),
                _feelingChip('Bon', 'good', '😊'),
                _feelingChip('Difficile', 'hard', '😓'),
                _feelingChip('Très difficile', 'veryhard', '😫'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _feelingChip(String label, String value, String emoji) {
    return ChoiceChip(
      label: Text('$emoji $label'),
      selected: _selectedFeeling == value,
      onSelected: (selected) {
        setState(() => _selectedFeeling = value);
      },
      selectedColor: _color,
      labelStyle: TextStyle(
        color: _selectedFeeling == value ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (optionnel)',
        border: OutlineInputBorder(),
        filled: true,
      ),
      maxLines: 3,
    );
  }

  Widget _buildStartTimerButton() {
    return OutlinedButton.icon(
      onPressed: _startIntervalTimer,
      icon: const Icon(Icons.timer),
      label: const Text(
        'Démarrer le timer d\'intervalles',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: _color,
        side: BorderSide(color: _color, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveRun,
      style: ElevatedButton.styleFrom(
        backgroundColor: _color,
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

  void _startIntervalTimer() {
    // Validate required fields
    if (_runMinutesController.text.isEmpty ||
        _walkMinutesController.text.isEmpty ||
        _cyclesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir les intervalles avant de démarrer'),
        ),
      );
      return;
    }

    final runMinutes = int.parse(_runMinutesController.text);
    final walkMinutes = int.parse(_walkMinutesController.text);
    final cycles = int.parse(_cyclesController.text);

    // Configure the interval timer
    final timerService = context.read<IntervalTimerService>();
    timerService.configure(
      runMinutes: runMinutes,
      walkMinutes: walkMinutes,
      cycles: cycles,
    );

    // Navigate to interval timer screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IntervalTimerScreen(),
      ),
    );
  }

  void _saveRun() {
    if (_formKey.currentState!.validate()) {
      final run = Run(
        date: _selectedDate,
        week: _selectedWeek,
        runMinutes: int.parse(_runMinutesController.text),
        walkMinutes: int.parse(_walkMinutesController.text),
        cycles: int.parse(_cyclesController.text),
        feeling: _selectedFeeling,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      context.read<RunProvider>().addRun(run);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tu progresses!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _runMinutesController.dispose();
    _walkMinutesController.dispose();
    _cyclesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
