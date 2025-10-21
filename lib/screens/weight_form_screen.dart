import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/weight.dart';
import '../providers/weight_provider.dart';

class WeightFormScreen extends StatefulWidget {
  const WeightFormScreen({super.key});

  @override
  State<WeightFormScreen> createState() => _WeightFormScreenState();
}

class _WeightFormScreenState extends State<WeightFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weightProvider = context.watch<WeightProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('POIDS'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (weightProvider.currentWeight != null) _buildCurrentWeightCard(context, weightProvider),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 24),
            _buildWeightField(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeightCard(BuildContext context, WeightProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_weight, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Poids actuel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${provider.currentWeight!.toStringAsFixed(1)} lbs',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (provider.totalWeightChange != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    provider.totalWeightChange! > 0 ? Icons.trending_up : Icons.trending_down,
                    color: provider.totalWeightChange! > 0 ? Colors.red : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.getWeightTrend(),
                    style: TextStyle(
                      fontSize: 16,
                      color: provider.totalWeightChange! > 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(' depuis le début'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
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

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      decoration: InputDecoration(
        labelText: 'Poids (lbs)',
        border: const OutlineInputBorder(),
        filled: true,
        prefixIcon: Icon(Icons.monitor_weight, color: Theme.of(context).colorScheme.primary),
        helperText: 'Entrez votre poids en livres',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre poids';
        }
        final weight = double.tryParse(value);
        if (weight == null || weight <= 0) {
          return 'Veuillez entrer un poids valide';
        }
        return null;
      },
      autofocus: true,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (optionnel)',
        border: OutlineInputBorder(),
        filled: true,
        hintText: 'Sentiment, objectif, etc.',
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveWeight,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
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

  void _saveWeight() {
    if (_formKey.currentState!.validate()) {
      final weight = Weight(
        date: _selectedDate,
        weightLbs: double.parse(_weightController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      context.read<WeightProvider>().addWeight(weight);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poids enregistré!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
