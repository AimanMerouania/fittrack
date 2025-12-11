part of 'workouts_list_cubit.dart';

enum WorkoutsListStatus { initial, loading, success, failure }

class WorkoutsListState extends Equatable {
  final List<WorkoutEntity> workouts;
  final WorkoutsListStatus status;

  const WorkoutsListState({
    this.workouts = const [],
    this.status = WorkoutsListStatus.initial,
  });

  WorkoutsListState copyWith({
    List<WorkoutEntity>? workouts,
    WorkoutsListStatus? status,
  }) {
    return WorkoutsListState(
      workouts: workouts ?? this.workouts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [workouts, status];
}
