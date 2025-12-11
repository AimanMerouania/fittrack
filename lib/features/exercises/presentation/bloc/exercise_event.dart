part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class ExerciseFetchStarted extends ExerciseEvent {}

class ExerciseSearchChanged extends ExerciseEvent {
  final String query;
  const ExerciseSearchChanged(this.query);
  
  @override
  List<Object> get props => [query];
}

class ExerciseBodyPartFilterChanged extends ExerciseEvent {
  final String? bodyPart;
  const ExerciseBodyPartFilterChanged(this.bodyPart);

  @override
  List<Object> get props => [bodyPart ?? ''];
}

class ExerciseAdded extends ExerciseEvent {
  final ExerciseEntity exercise;
  const ExerciseAdded(this.exercise);

  @override
  List<Object> get props => [exercise];
}
