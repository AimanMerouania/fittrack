import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/scheduled_workout_entity.dart';
import '../../domain/repositories/calendar_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepository _repository;

  CalendarCubit({required CalendarRepository repository})
      : _repository = repository,
        super(CalendarState());

  /// Charger les séances pour un mois donné
  Future<void> loadMonth(DateTime month) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    try {
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0);

      final workouts =
          await _repository.getScheduledWorkoutsForRange(start, end);

      emit(state.copyWith(
        status: CalendarStatus.success,
        scheduledWorkouts: workouts,
        selectedMonth: month,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Sélectionner un jour
  Future<void> selectDay(DateTime day) async {
    emit(state.copyWith(selectedDay: day));

    try {
      final workouts = await _repository.getScheduledWorkoutsForDay(day);
      emit(state.copyWith(selectedDayWorkouts: workouts));
    } catch (e) {
      print('Erreur lors du chargement des séances du jour: $e');
    }
  }

  /// Planifier une nouvelle séance
  Future<void> scheduleWorkout(ScheduledWorkoutEntity workout) async {
    try {
      await _repository.scheduleWorkout(workout);
      await loadMonth(state.selectedMonth);
      await selectDay(workout.scheduledDate);
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: 'Erreur lors de la planification: $e',
      ));
    }
  }

  /// Mettre à jour une séance
  Future<void> updateWorkout(ScheduledWorkoutEntity workout) async {
    try {
      await _repository.updateScheduledWorkout(workout);
      await loadMonth(state.selectedMonth);
      await selectDay(workout.scheduledDate);
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: 'Erreur lors de la mise à jour: $e',
      ));
    }
  }

  /// Supprimer une séance
  Future<void> deleteWorkout(String id) async {
    try {
      await _repository.deleteScheduledWorkout(id);
      await loadMonth(state.selectedMonth);
      if (state.selectedDay != null) {
        await selectDay(state.selectedDay!);
      }
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: 'Erreur lors de la suppression: $e',
      ));
    }
  }

  /// Marquer comme complété
  Future<void> markAsCompleted(String id, {int? duration}) async {
    try {
      await _repository.markWorkoutAsCompleted(id, duration: duration);
      await loadMonth(state.selectedMonth);
      if (state.selectedDay != null) {
        await selectDay(state.selectedDay!);
      }
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: 'Erreur lors de la complétion: $e',
      ));
    }
  }

  /// Replanifier une séance
  Future<void> rescheduleWorkout(String id, DateTime newDate) async {
    try {
      await _repository.rescheduleWorkout(id, newDate);
      await loadMonth(state.selectedMonth);
      await selectDay(newDate);
    } catch (e) {
      emit(state.copyWith(
        status: CalendarStatus.failure,
        errorMessage: 'Erreur lors de la replanification: $e',
      ));
    }
  }

  /// Obtenir les séances pour un jour spécifique (pour les markers)
  List<ScheduledWorkoutEntity> getWorkoutsForDay(DateTime day) {
    return state.scheduledWorkouts.where((workout) {
      final date = workout.scheduledDate;
      return date.year == day.year &&
          date.month == day.month &&
          date.day == day.day;
    }).toList();
  }
}
