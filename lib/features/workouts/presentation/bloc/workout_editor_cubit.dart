import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../../exercises/domain/entities/exercise_entity.dart';

part 'workout_editor_state.dart';

class WorkoutEditorCubit extends Cubit<WorkoutEditorState> {
  final WorkoutRepository _repository;
  final Uuid _uuid = const Uuid();

  WorkoutEditorCubit({required WorkoutRepository repository})
      : _repository = repository,
        super(const WorkoutEditorState());

  void nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void addExercise(ExerciseEntity exercise) {
    final newWorkoutExercise = WorkoutExerciseEntity(
      id: _uuid.v4(),
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      sets: [
        ExerciseSetEntity(
          id: _uuid.v4(),
          index: 0,
          weight: 0,
          reps: 10,
        )
      ],
    );

    final updatedExercises = List<WorkoutExerciseEntity>.from(state.exercises)
      ..add(newWorkoutExercise);
    
    emit(state.copyWith(exercises: updatedExercises));
  }

  void addSet(String workoutExerciseId) {
    final exercises = state.exercises.map((e) {
      if (e.id == workoutExerciseId) {
        final newSets = List<ExerciseSetEntity>.from(e.sets)
          ..add(ExerciseSetEntity(
            id: _uuid.v4(),
            index: e.sets.length,
            weight: e.sets.isNotEmpty ? e.sets.last.weight : 0,
            reps: e.sets.isNotEmpty ? e.sets.last.reps : 10,
          ));
        return WorkoutExerciseEntity(
          id: e.id,
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          sets: newSets,
        );
      }
      return e;
    }).toList();
    
    emit(state.copyWith(exercises: exercises));
  }

  void removeSet(String workoutExerciseId, int setIndex) {
     final exercises = state.exercises.map((e) {
      if (e.id == workoutExerciseId) {
        final newSets = List<ExerciseSetEntity>.from(e.sets);
        if (newSets.length > 1) {
           newSets.removeAt(setIndex);
        }
        return WorkoutExerciseEntity(
          id: e.id,
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          sets: newSets,
        );
      }
      return e;
    }).toList();
    
    emit(state.copyWith(exercises: exercises));
  }

  Future<void> saveWorkout() async {
    if (state.name.isEmpty || state.exercises.isEmpty) return;
    
    emit(state.copyWith(status: WorkoutEditorStatus.saving));
    
    try {
      final workout = WorkoutEntity(
        id: _uuid.v4(),
        name: state.name,
        date: DateTime.now(),
        exercises: state.exercises,
        isTemplate: true, // Par défaut on crée un template ici
      );
      
      await _repository.saveWorkout(workout);
      emit(state.copyWith(status: WorkoutEditorStatus.success));
    } catch (_) {
      emit(state.copyWith(status: WorkoutEditorStatus.failure));
    }
  }
}
