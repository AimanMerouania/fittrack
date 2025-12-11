part of 'workout_editor_cubit.dart';

enum WorkoutEditorStatus { initial, saving, success, failure }

class WorkoutEditorState extends Equatable {
  final String name;
  final List<WorkoutExerciseEntity> exercises;
  final WorkoutEditorStatus status;

  const WorkoutEditorState({
    this.name = '',
    this.exercises = const [],
    this.status = WorkoutEditorStatus.initial,
  });

  WorkoutEditorState copyWith({
    String? name,
    List<WorkoutExerciseEntity>? exercises,
    WorkoutEditorStatus? status,
  }) {
    return WorkoutEditorState(
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [name, exercises, status];
}
