import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';

part 'workouts_list_state.dart';

class WorkoutsListCubit extends Cubit<WorkoutsListState> {
  final WorkoutRepository _repository;

  WorkoutsListCubit(this._repository) : super(const WorkoutsListState());

  Future<void> loadWorkouts() async {
    emit(state.copyWith(status: WorkoutsListStatus.loading));
    try {
      final workouts = await _repository.getWorkouts(templatesOnly: true); // On charge que les templates
      emit(state.copyWith(
        status: WorkoutsListStatus.success,
        workouts: workouts,
      ));
    } catch (_) {
      emit(state.copyWith(status: WorkoutsListStatus.failure));
    }
  }
}
