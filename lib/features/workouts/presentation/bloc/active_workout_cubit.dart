import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';

part 'active_workout_state.dart';

class ActiveWorkoutCubit extends Cubit<ActiveWorkoutState> {
  final WorkoutRepository _repository;
  final Uuid _uuid = const Uuid();
  Timer? _timer;

  ActiveWorkoutCubit({
    required WorkoutRepository repository,
    required WorkoutEntity template,
  }) : _repository = repository,
       super(ActiveWorkoutState(
         // On crée une copie du template pour la séance active
         // On passe isTemplate à false et on met la date actuelle
         workout: _createActiveWorkout(template),
         elapsedSeconds: 0,
       )) {
    _startTimer();
  }

  static WorkoutEntity _createActiveWorkout(WorkoutEntity template) {
    // Créer une copie avec de nouveaux IDs pour l'historique serait idéal pour une vraie DB relationnelle
    // Pour l'instant, disons qu'on copie la structure
    return WorkoutEntity(
      id: const Uuid().v4(),
      name: template.name,
      date: DateTime.now(),
      exercises: template.exercises.map((e) => 
        WorkoutExerciseEntity(
          id: const Uuid().v4(),
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          notes: e.notes,
          sets: e.sets.map((s) => ExerciseSetEntity(
            id: const Uuid().v4(),
            index: s.index,
            weight: s.weight,
            reps: s.reps,
            isCompleted: false, // Reset completion
          )).toList(),
        )
      ).toList(),
      isTemplate: false,
    );
  }

  Timer? _restTimer;
  int _restSecondsRemaining = 0;

  @override
  Future<void> close() {
    _timer?.cancel();
    _restTimer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
    });
  }

  void updateSet(String workoutExerciseId, int setIndex, {double? weight, int? reps}) {
    final updatedExercises = state.workout.exercises.map((e) {
      if (e.id == workoutExerciseId) {
        final updatedSets = List<ExerciseSetEntity>.from(e.sets);
        final currentSet = updatedSets[setIndex];
        updatedSets[setIndex] = ExerciseSetEntity(
          id: currentSet.id,
          index: currentSet.index,
          reps: reps ?? currentSet.reps,
          weight: weight ?? currentSet.weight,
          isCompleted: currentSet.isCompleted,
        );
        return WorkoutExerciseEntity(
          id: e.id,
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          notes: e.notes,
          sets: updatedSets,
        );
      }
      return e;
    }).toList();

    _emitUpdatedWorkout(updatedExercises);
  }

  void toggleSetInitial(String workoutExerciseId, int setIndex) {
    bool isCompletedNow = false;

    final updatedExercises = state.workout.exercises.map((e) {
      if (e.id == workoutExerciseId) {
        final updatedSets = List<ExerciseSetEntity>.from(e.sets);
        final currentSet = updatedSets[setIndex];
        
        isCompletedNow = !currentSet.isCompleted;
        
        updatedSets[setIndex] = ExerciseSetEntity(
          id: currentSet.id,
          index: currentSet.index,
          reps: currentSet.reps,
          weight: currentSet.weight,
          isCompleted: isCompletedNow,
        );
        return WorkoutExerciseEntity(
          id: e.id,
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          notes: e.notes,
          sets: updatedSets,
        );
      }
      return e;
    }).toList();

    _emitUpdatedWorkout(updatedExercises);
    
    // Auto-start Rest Timer if set completed
    if (isCompletedNow) {
      _startRestTimer();
    }
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restSecondsRemaining = 90; // 1m30 default
    emit(state.copyWith(restTimerSeconds: _restSecondsRemaining));

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining <= 0) {
        timer.cancel();
        emit(state.copyWith(restTimerSeconds: 0));
      } else {
        _restSecondsRemaining--;
        emit(state.copyWith(restTimerSeconds: _restSecondsRemaining));
      }
    });
  }
  
  void cancelRestTimer() {
    _restTimer?.cancel();
    emit(state.copyWith(restTimerSeconds: 0));
  }

  void addRestTime(int seconds) {
     _restSecondsRemaining += seconds;
     emit(state.copyWith(restTimerSeconds: _restSecondsRemaining));
  }


  void _emitUpdatedWorkout(List<WorkoutExerciseEntity> updatedExercises) {
    emit(state.copyWith(
      workout: WorkoutEntity(
        id: state.workout.id,
        name: state.workout.name,
        date: state.workout.date,
        duration: state.elapsedSeconds,
        exercises: updatedExercises,
        isTemplate: false,
      )
    ));
  }


  Future<void> finishWorkout() async {
    _timer?.cancel();
    emit(state.copyWith(status: ActiveWorkoutStatus.saving));
    
    try {
      final finishedWorkout = WorkoutEntity(
        id: state.workout.id,
        name: state.workout.name,
        date: DateTime.now(), // Date de fin
        duration: state.elapsedSeconds,
        exercises: state.workout.exercises,
        notes: state.workout.notes,
        isTemplate: false,
      );

      await _repository.saveWorkout(finishedWorkout);
      emit(state.copyWith(status: ActiveWorkoutStatus.success));
    } catch (_) {
       emit(state.copyWith(status: ActiveWorkoutStatus.failure));
    }
  }


}
