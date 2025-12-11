import '../../domain/entities/scheduled_workout_entity.dart';
import '../../domain/repositories/calendar_repository.dart';

/// Implémentation Mock du CalendarRepository (en mémoire)
class MockCalendarRepository implements CalendarRepository {
  final List<ScheduledWorkoutEntity> _scheduledWorkouts = [];

  MockCalendarRepository() {
    // Ajouter quelques séances d'exemple
    final now = DateTime.now();
    _scheduledWorkouts.addAll([
      // Aujourd'hui
      ScheduledWorkoutEntity(
        id: '1',
        workoutId: '1',
        workoutName: 'Programme Pectoraux',
        scheduledDate: DateTime(now.year, now.month, now.day, 10, 0),
        type: WorkoutType.strength,
        notes: 'Focus sur la technique',
      ),

      // Demain
      ScheduledWorkoutEntity(
        id: '2',
        workoutId: '2',
        workoutName: 'Programme Dos',
        scheduledDate: DateTime(now.year, now.month, now.day + 1, 14, 0),
        type: WorkoutType.strength,
      ),

      // Dans 2 jours
      ScheduledWorkoutEntity(
        id: '3',
        workoutId: '3',
        workoutName: 'Programme Jambes',
        scheduledDate: DateTime(now.year, now.month, now.day + 2, 10, 0),
        type: WorkoutType.lowerBody,
      ),

      // Dans 3 jours
      ScheduledWorkoutEntity(
        id: '4',
        workoutId: 'cardio-1',
        workoutName: 'Cardio HIIT',
        scheduledDate: DateTime(now.year, now.month, now.day + 3, 18, 0),
        type: WorkoutType.cardio,
      ),

      // Hier (complété)
      ScheduledWorkoutEntity(
        id: '5',
        workoutId: '1',
        workoutName: 'Programme Pectoraux',
        scheduledDate: DateTime(now.year, now.month, now.day - 1, 10, 0),
        type: WorkoutType.strength,
        isCompleted: true,
        completedAt: DateTime(now.year, now.month, now.day - 1, 11, 30),
        duration: 90,
      ),

      // Il y a 2 jours (complété)
      ScheduledWorkoutEntity(
        id: '6',
        workoutId: '2',
        workoutName: 'Programme Dos',
        scheduledDate: DateTime(now.year, now.month, now.day - 2, 14, 0),
        type: WorkoutType.strength,
        isCompleted: true,
        completedAt: DateTime(now.year, now.month, now.day - 2, 15, 15),
        duration: 75,
      ),
    ]);
  }

  @override
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_scheduledWorkouts);
  }

  @override
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsForRange(
    DateTime start,
    DateTime end,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _scheduledWorkouts.where((workout) {
      final date = workout.scheduledDate;
      return date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsForDay(
    DateTime day,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _scheduledWorkouts.where((workout) {
      final date = workout.scheduledDate;
      return date.year == day.year &&
          date.month == day.month &&
          date.day == day.day;
    }).toList();
  }

  @override
  Future<void> scheduleWorkout(ScheduledWorkoutEntity workout) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scheduledWorkouts.add(workout);
    print(
        '✅ Séance planifiée: ${workout.workoutName} le ${workout.scheduledDate}');
  }

  @override
  Future<void> updateScheduledWorkout(ScheduledWorkoutEntity workout) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _scheduledWorkouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _scheduledWorkouts[index] = workout;
      print('✏️ Séance mise à jour: ${workout.workoutName}');
    }
  }

  @override
  Future<void> deleteScheduledWorkout(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _scheduledWorkouts.removeWhere((w) => w.id == id);
    print('🗑️ Séance supprimée: $id');
  }

  @override
  Future<void> markWorkoutAsCompleted(String id, {int? duration}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _scheduledWorkouts.indexWhere((w) => w.id == id);
    if (index != -1) {
      _scheduledWorkouts[index] = _scheduledWorkouts[index].copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        duration: duration,
      );
      print('✅ Séance complétée: ${_scheduledWorkouts[index].workoutName}');
    }
  }

  @override
  Future<void> rescheduleWorkout(String id, DateTime newDate) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _scheduledWorkouts.indexWhere((w) => w.id == id);
    if (index != -1) {
      _scheduledWorkouts[index] = _scheduledWorkouts[index].copyWith(
        scheduledDate: newDate,
      );
      print(
          '📅 Séance replanifiée: ${_scheduledWorkouts[index].workoutName} → $newDate');
    }
  }
}
