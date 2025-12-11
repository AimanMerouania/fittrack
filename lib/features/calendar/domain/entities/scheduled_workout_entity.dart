import 'package:equatable/equatable.dart';

/// Entité représentant une séance d'entraînement planifiée dans le calendrier
class ScheduledWorkoutEntity extends Equatable {
  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime scheduledDate;
  final String? notes;
  final WorkoutType type;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? duration; // en minutes

  const ScheduledWorkoutEntity({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.scheduledDate,
    this.notes,
    required this.type,
    this.isCompleted = false,
    this.completedAt,
    this.duration,
  });

  ScheduledWorkoutEntity copyWith({
    String? id,
    String? workoutId,
    String? workoutName,
    DateTime? scheduledDate,
    String? notes,
    WorkoutType? type,
    bool? isCompleted,
    DateTime? completedAt,
    int? duration,
  }) {
    return ScheduledWorkoutEntity(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      workoutName: workoutName ?? this.workoutName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        workoutId,
        workoutName,
        scheduledDate,
        notes,
        type,
        isCompleted,
        completedAt,
        duration,
      ];
}

/// Types d'entraînement pour la catégorisation et les couleurs
enum WorkoutType {
  strength, // Force (Rouge/Orange)
  cardio, // Cardio (Bleu)
  flexibility, // Flexibilité (Vert)
  fullBody, // Full Body (Violet)
  upperBody, // Haut du corps (Cyan)
  lowerBody, // Bas du corps (Jaune)
  custom, // Personnalisé (Gris)
}

extension WorkoutTypeExtension on WorkoutType {
  String get displayName {
    switch (this) {
      case WorkoutType.strength:
        return 'Force';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.flexibility:
        return 'Flexibilité';
      case WorkoutType.fullBody:
        return 'Full Body';
      case WorkoutType.upperBody:
        return 'Haut du Corps';
      case WorkoutType.lowerBody:
        return 'Bas du Corps';
      case WorkoutType.custom:
        return 'Personnalisé';
    }
  }

  String get emoji {
    switch (this) {
      case WorkoutType.strength:
        return '💪';
      case WorkoutType.cardio:
        return '🏃';
      case WorkoutType.flexibility:
        return '🧘';
      case WorkoutType.fullBody:
        return '🔥';
      case WorkoutType.upperBody:
        return '💪';
      case WorkoutType.lowerBody:
        return '🦵';
      case WorkoutType.custom:
        return '⭐';
    }
  }
}
