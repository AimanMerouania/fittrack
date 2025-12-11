import 'package:equatable/equatable.dart';

/// Un entraînement complet (ex: "Séance Pectoraux/Biceps")
class WorkoutEntity extends Equatable {
  final String id;
  final String name;
  final DateTime? date; // Date de réalisation (null si c'est un template/programme à suivre)
  final int duration; // en secondes
  final List<WorkoutExerciseEntity> exercises;
  final String notes;
  final bool isTemplate; // True = modèle réutilisable, False = séance réalisée

  const WorkoutEntity({
    required this.id,
    required this.name,
    this.date,
    this.duration = 0,
    required this.exercises,
    this.notes = '',
    this.isTemplate = false,
  });

  @override
  List<Object?> get props => [id, name, date, duration, exercises, notes, isTemplate];
}

/// Un exercice dans un entraînement (ex: "Bench Press - 4 séries")
class WorkoutExerciseEntity extends Equatable {
  final String id; // ID unique dans le workout
  final String exerciseId; // Référence à l'exercice du catalogue
  final String exerciseName; // Copie du nom pour affichage rapide
  final List<ExerciseSetEntity> sets;
  final String notes;

  const WorkoutExerciseEntity({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.notes = '',
  });

  @override
  List<Object?> get props => [id, exerciseId, exerciseName, sets, notes];
}

/// Une série (ex: "10 reps @ 60kg")
class ExerciseSetEntity extends Equatable {
  final String id;
  final int index; // Ordre de la série
  final double weight;
  final int reps;
  final bool isCompleted;

  const ExerciseSetEntity({
    required this.id,
    required this.index,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, index, weight, reps, isCompleted];
}
