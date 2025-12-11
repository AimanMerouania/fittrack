import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/exercise_entity.dart';

class ExerciseCreatorPage extends StatefulWidget {
  const ExerciseCreatorPage({super.key});

  @override
  State<ExerciseCreatorPage> createState() => _ExerciseCreatorPageState();
}

class _ExerciseCreatorPageState extends State<ExerciseCreatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedBodyPart = 'chest';
  String _selectedTarget = 'pectorals';
  String _selectedEquipment = 'body weight';

  final List<String> _bodyParts = [
    'chest',
    'back',
    'scoulders', // intentional typo in dataset often
    'legs',
    'arms',
    'core',
    'cardio'
  ];

  final List<String> _equipment = [
    'body weight',
    'dumbbell',
    'barbell',
    'machine',
    'cable',
    'kettlebell',
    'band'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newExercise = ExerciseEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        bodyPart: _selectedBodyPart,
        target: _selectedTarget,
        equipment: _selectedEquipment,
        gifUrl: '', // No image for custom exercise for now
        isFavorite: true,
      );

      Navigator.of(context).pop(newExercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('NOUVEL EXERCICE'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              AppTheme.darkBackground.withRed(20),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const Text(
                    'Créez votre propre exercice personnalisé',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ).animate().fadeIn().slideY(),
                  const SizedBox(height: 32),
                  
                  // Name Input
                  GlassCard(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nom de l\'exercice',
                        prefixIcon: Icon(Icons.fitness_center),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(),

                  const SizedBox(height: 16),

                  // Body Part Selector
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBodyPart,
                        dropdownColor: AppTheme.surfaceColor,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: AppTheme.neonBlue),
                        items: _bodyParts.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBodyPart = newValue!;
                          });
                        },
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(),
                  
                   const SizedBox(height: 16),

                   // Equipment Selector
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedEquipment,
                        dropdownColor: AppTheme.surfaceColor,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: AppTheme.neonPurple),
                        items: _equipment.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedEquipment = newValue!;
                          });
                        },
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonBlue,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'CRÉER L\'EXERCICE',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
