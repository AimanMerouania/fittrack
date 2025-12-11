import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../workouts/domain/entities/workout_entity.dart';
import '../../../workouts/domain/repositories/workout_repository.dart';

class StatsCubit extends Cubit<StatsState> {
  final WorkoutRepository _repository;

  StatsCubit(this._repository) : super(const StatsState());

  Future<void> loadStats() async {
    emit(state.copyWith(status: StatsStatus.loading));
    try {
      final history = await _repository.getWorkouts(templatesOnly: false);
      final completedWorkouts = history.where((w) => !w.isTemplate && w.date != null).toList();
      
      final weeklyVolume = _calculateWeeklyVolume(completedWorkouts);
      final muscleDistribution = _calculateMuscleDistribution(completedWorkouts);

      emit(state.copyWith(
        status: StatsStatus.success,
        history: completedWorkouts,
        weeklyVolume: weeklyVolume,
        muscleDistribution: muscleDistribution,
      ));
    } catch (_) {
      emit(state.copyWith(status: StatsStatus.failure));
    }
  }

  // Returns array of 7 ints (Mon-Sun)
  List<int> _calculateWeeklyVolume(List<WorkoutEntity> workouts) {
    final now = DateTime.now();
    // Find start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfNextWeek = startOfWeek.add(const Duration(days: 7));
    
    final volume = List<int>.filled(7, 0);

    for (var w in workouts) {
      if (w.date!.isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
          w.date!.isBefore(startOfNextWeek)) {
        // weekday: 1=Mon, 7=Sun. List index: 0-6
        volume[w.date!.weekday - 1]++; 
      }
    }
    return volume;
  }

  Map<String, int> _calculateMuscleDistribution(List<WorkoutEntity> workouts) {
    final distribution = <String, int>{};
    
    // Basic heuristics based on workout name since we don't have full exercise details lookup here easily
    // In a real app we would join with ExerciseRepository
    for (var w in workouts) {
      final name = w.name.toLowerCase();
      if (name.contains('pec') || name.contains('chest')) {
        distribution.update('Pectoraux', (v) => v + 1, ifAbsent: () => 1);
      } else if (name.contains('dos') || name.contains('back')) {
        distribution.update('Dos', (v) => v + 1, ifAbsent: () => 1);
      } else if (name.contains('jambe') || name.contains('leg') || name.contains('squat')) {
        distribution.update('Jambes', (v) => v + 1, ifAbsent: () => 1);
      } else if (name.contains('bras') || name.contains('arm') || name.contains('curl')) {
        distribution.update('Bras', (v) => v + 1, ifAbsent: () => 1);
      } else {
        distribution.update('Autre', (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return distribution;
  }
}

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final StatsStatus status;
  final List<WorkoutEntity> history;
  final List<int> weeklyVolume;
  final Map<String, int> muscleDistribution;

  const StatsState({
    this.status = StatsStatus.initial,
    this.history = const [],
    this.weeklyVolume = const [],
    this.muscleDistribution = const {},
  });

  StatsState copyWith({
    StatsStatus? status,
    List<WorkoutEntity>? history,
    List<int>? weeklyVolume,
    Map<String, int>? muscleDistribution,
  }) {
    return StatsState(
      status: status ?? this.status,
      history: history ?? this.history,
      weeklyVolume: weeklyVolume ?? this.weeklyVolume,
      muscleDistribution: muscleDistribution ?? this.muscleDistribution,
    );
  }

  @override
  List<Object> get props => [status, history, weeklyVolume, muscleDistribution];
}
