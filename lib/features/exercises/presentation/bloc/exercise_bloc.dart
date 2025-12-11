import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseBloc({required ExerciseRepository exerciseRepository})
      : _exerciseRepository = exerciseRepository,
        super(const ExerciseState()) {
    on<ExerciseFetchStarted>(_onFetchStarted);
    on<ExerciseSearchChanged>(_onSearchChanged, transformer: debounce(_debounceDuration));
    on<ExerciseBodyPartFilterChanged>(_onFilterChanged);
    on<ExerciseAdded>(_onExerciseAdded);
  }

  Future<void> _onFetchStarted(
    ExerciseFetchStarted event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseStatus.loading));
    try {
      final exercises = await _exerciseRepository.getExercises();
      emit(state.copyWith(
        status: ExerciseStatus.success,
        exercises: exercises,
      ));
    } catch (_) {
      emit(state.copyWith(status: ExerciseStatus.failure));
    }
  }

  Future<void> _onSearchChanged(
    ExerciseSearchChanged event,
    Emitter<ExerciseState> emit,
  ) async {
    final query = event.query;
    if (query.isEmpty) {
      add(ExerciseFetchStarted());
      return;
    }

    emit(state.copyWith(status: ExerciseStatus.loading, searchQuery: query));
    try {
      final exercises = await _exerciseRepository.searchExercises(query);
      emit(state.copyWith(
        status: ExerciseStatus.success,
        exercises: exercises,
      ));
    } catch (_) {
      emit(state.copyWith(status: ExerciseStatus.failure));
    }
  }

  Future<void> _onFilterChanged(
    ExerciseBodyPartFilterChanged event,
    Emitter<ExerciseState> emit,
  ) async {
    final bodyPart = event.bodyPart;
    emit(state.copyWith(status: ExerciseStatus.loading)); // Reset list visually
    
    // Note: Dans une vraie implémentation, on combinerait recherche + filtre
    try {
      List<ExerciseEntity> exercises;
      if (bodyPart != null && bodyPart.isNotEmpty) {
        exercises = await _exerciseRepository.getExercisesByBodyPart(bodyPart);
      } else {
        exercises = await _exerciseRepository.getExercises();
      }
      
      emit(state.copyWith(
        status: ExerciseStatus.success,
        exercises: exercises,
        filterBodyPart: bodyPart,
      ));
    } catch (_) {
      emit(state.copyWith(status: ExerciseStatus.failure));
    }
  }

  Future<void> _onExerciseAdded(
    ExerciseAdded event,
    Emitter<ExerciseState> emit,
  ) async {
    // Optimistic Update could go here, but for simplicity we reload
    try {
      await _exerciseRepository.addExercise(event.exercise);
      // Reload list to confirm add
      add(ExerciseFetchStarted());
    } catch (_) {
      // Handle add failure
    }
  }
}
