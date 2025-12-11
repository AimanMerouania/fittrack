import '../entities/scheduled_workout_entity.dart';

/// Repository pour gérer les séances d'entraînement planifiées
abstract class CalendarRepository {
  /// Récupérer toutes les séances planifiées
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkouts();

  /// Récupérer les séances pour une période donnée
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsForRange(
    DateTime start,
    DateTime end,
  );

  /// Récupérer les séances pour un jour spécifique
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsForDay(DateTime day);

  /// Créer une nouvelle séance planifiée
  Future<void> scheduleWorkout(ScheduledWorkoutEntity workout);

  /// Mettre à jour une séance planifiée
  Future<void> updateScheduledWorkout(ScheduledWorkoutEntity workout);

  /// Supprimer une séance planifiée
  Future<void> deleteScheduledWorkout(String id);

  /// Marquer une séance comme complétée
  Future<void> markWorkoutAsCompleted(String id, {int? duration});

  /// Déplacer une séance vers une autre date
  Future<void> rescheduleWorkout(String id, DateTime newDate);
}
