part of 'active_workout_cubit.dart';

enum ActiveWorkoutStatus { initial, inProgress, saving, success, failure }

class ActiveWorkoutState extends Equatable {
  final WorkoutEntity workout;
  final int elapsedSeconds;
  final ActiveWorkoutStatus status;
  final int restTimerSeconds;

  const ActiveWorkoutState({
    required this.workout,
    required this.elapsedSeconds,
    this.status = ActiveWorkoutStatus.initial,
    this.restTimerSeconds = 0,
  });

  ActiveWorkoutState copyWith({
    WorkoutEntity? workout,
    int? elapsedSeconds,
    ActiveWorkoutStatus? status,
    int? restTimerSeconds,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
    );
  }

  @override
  List<Object> get props => [workout, elapsedSeconds, status, restTimerSeconds];
}
