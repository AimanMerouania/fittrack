part of 'exercise_bloc.dart';

enum ExerciseStatus { initial, loading, success, failure }

class ExerciseState extends Equatable {
  final ExerciseStatus status;
  final List<ExerciseEntity> exercises;
  final String? filterBodyPart;
  final String searchQuery;

  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.exercises = const <ExerciseEntity>[],
    this.filterBodyPart,
    this.searchQuery = '',
  });

  ExerciseState copyWith({
    ExerciseStatus? status,
    List<ExerciseEntity>? exercises,
    String? filterBodyPart,
    String? searchQuery,
  }) {
    return ExerciseState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      filterBodyPart: filterBodyPart, // Nullable update logic is tricky here, keeping simple
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, exercises, filterBodyPart, searchQuery];
}
