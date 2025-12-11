import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';

/// Mock repository pour les workouts (fonctionne en mémoire)
class MockWorkoutRepository implements WorkoutRepository {
  final List<WorkoutEntity> _workouts = [];

  MockWorkoutRepository() {
    // Ajouter quelques programmes d'exemple
    _workouts.addAll([
      WorkoutEntity(
        id: '1',
        name: 'Programme Pectoraux',
        date: null,
        duration: 0,
        notes: '',
        isTemplate: true,
        exercises: [
          WorkoutExerciseEntity(
            id: 'ex1',
            exerciseId: 'bench-press',
            exerciseName: 'Bench Press',
            notes: '',
            sets: [
              ExerciseSetEntity(
                  id: 's1', index: 0, weight: 60, reps: 10, isCompleted: false),
              ExerciseSetEntity(
                  id: 's2', index: 1, weight: 70, reps: 8, isCompleted: false),
              ExerciseSetEntity(
                  id: 's3', index: 2, weight: 80, reps: 6, isCompleted: false),
            ],
          ),
          WorkoutExerciseEntity(
            id: 'ex2',
            exerciseId: 'incline-bench',
            exerciseName: 'Incline Bench Press',
            notes: '',
            sets: [
              ExerciseSetEntity(
                  id: 's4', index: 0, weight: 50, reps: 10, isCompleted: false),
              ExerciseSetEntity(
                  id: 's5', index: 1, weight: 55, reps: 8, isCompleted: false),
            ],
          ),
        ],
      ),
      WorkoutEntity(
        id: '2',
        name: 'Programme Dos',
        date: null,
        duration: 0,
        notes: '',
        isTemplate: true,
        exercises: [
          WorkoutExerciseEntity(
            id: 'ex3',
            exerciseId: 'deadlift',
            exerciseName: 'Deadlift',
            notes: '',
            sets: [
              ExerciseSetEntity(
                  id: 's6', index: 0, weight: 100, reps: 5, isCompleted: false),
              ExerciseSetEntity(
                  id: 's7', index: 1, weight: 110, reps: 5, isCompleted: false),
              ExerciseSetEntity(
                  id: 's8', index: 2, weight: 120, reps: 3, isCompleted: false),
            ],
          ),
          WorkoutExerciseEntity(
            id: 'ex4',
            exerciseId: 'pull-up',
            exerciseName: 'Pull Up',
            notes: '',
            sets: [
              ExerciseSetEntity(
                  id: 's9', index: 0, weight: 0, reps: 10, isCompleted: false),
              ExerciseSetEntity(
                  id: 's10', index: 1, weight: 0, reps: 8, isCompleted: false),
              ExerciseSetEntity(
                  id: 's11', index: 2, weight: 0, reps: 6, isCompleted: false),
            ],
          ),
        ],
      ),
      WorkoutEntity(
        id: '3',
        name: 'Programme Jambes',
        date: null,
        duration: 0,
        notes: '',
        isTemplate: true,
        exercises: [
          WorkoutExerciseEntity(
            id: 'ex5',
            exerciseId: 'squat',
            exerciseName: 'Squat',
            notes: '',
            sets: [
              ExerciseSetEntity(
                  id: 's12',
                  index: 0,
                  weight: 80,
                  reps: 10,
                  isCompleted: false),
              ExerciseSetEntity(
                  id: 's13', index: 1, weight: 90, reps: 8, isCompleted: false),
              ExerciseSetEntity(
                  id: 's14',
                  index: 2,
                  weight: 100,
                  reps: 6,
                  isCompleted: false),
            ],
          ),
        ],
      ),
    ]);
    
    // Ajouter de l'historique pour les stats (7 derniers jours)
    final now = DateTime.now();
    _workouts.addAll([
      WorkoutEntity(
        id: 'hist1',
        name: 'Programme Pectoraux',
        date: now.subtract(const Duration(days: 1)),
        duration: 3600,
        isTemplate: false,
        exercises: _workouts[0].exercises, // Reuse basic structure
      ),
      WorkoutEntity(
        id: 'hist2',
        name: 'Programme Dos',
        date: now.subtract(const Duration(days: 3)),
        duration: 4500,
        isTemplate: false,
        exercises: _workouts[1].exercises,
      ),
      WorkoutEntity(
        id: 'hist3',
        name: 'Programme Jambes',
        date: now.subtract(const Duration(days: 5)),
        duration: 4000,
        isTemplate: false,
        exercises: _workouts[2].exercises,
      ),
      WorkoutEntity(
        id: 'hist4',
        name: 'Programme Pectoraux',
        date: now.subtract(const Duration(days: 6)),
        duration: 3800,
        isTemplate: false,
        exercises: _workouts[0].exercises,
      ),
    ]);
  }

  @override
  Future<List<WorkoutEntity>> getWorkouts({bool templatesOnly = false}) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));

    if (templatesOnly) {
      return _workouts.where((w) => w.isTemplate).toList();
    }
    return List.from(_workouts);
  }

  @override
  Future<void> saveWorkout(WorkoutEntity workout) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Supprimer l'ancien si existe
    _workouts.removeWhere((w) => w.id == workout.id);

    // Ajouter le nouveau
    _workouts.add(workout);

    print('✅ Programme sauvegardé: ${workout.name}');
    print('   Exercices: ${workout.exercises.length}');
  }

  @override
  Future<void> deleteWorkout(String id) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));

    _workouts.removeWhere((w) => w.id == id);
    print('🗑️ Programme supprimé: $id');
  }
}
