import 'package:sqflite/sqflite.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/local_database.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final LocalDatabase _dbProvider;

  WorkoutRepositoryImpl({LocalDatabase? dbProvider})
      : _dbProvider = dbProvider ?? LocalDatabase.instance;

  @override
  Future<List<WorkoutEntity>> getWorkouts({bool templatesOnly = false}) async {
    final db = await _dbProvider.database;
    final whereClause = templatesOnly ? 'isTemplate = 1' : 'isTemplate = 0';
    
    // 1. Récupérer les workouts
    final workoutMaps = await db.query(
      'workouts',
      where: whereClause,
      orderBy: 'date DESC',
    );

    List<WorkoutEntity> workouts = [];

    for (var wMap in workoutMaps) {
      final workoutId = wMap['id'] as String;

      // 2. Récupérer les exercices du workout
      final exerciseMaps = await db.query(
        'workout_exercises',
        where: 'workoutId = ?',
        whereArgs: [workoutId],
      );

      List<WorkoutExerciseEntity> exercises = [];

      for (var eMap in exerciseMaps) {
        final exerciseId = eMap['id'] as String;

        // 3. Récupérer les sets de l'exercice
        final setMaps = await db.query(
          'sets',
          where: 'workoutExerciseId = ?',
          whereArgs: [exerciseId],
          orderBy: 'setIndex ASC',
        );

        final sets = setMaps.map((s) => ExerciseSetEntity(
          id: s['id'] as String,
          index: s['setIndex'] as int,
          weight: (s['weight'] as num).toDouble(),
          reps: s['reps'] as int,
          isCompleted: (s['isCompleted'] as int) == 1,
        )).toList();

        exercises.add(WorkoutExerciseEntity(
          id: exerciseId,
          exerciseId: eMap['exerciseId'] as String,
          exerciseName: eMap['exerciseName'] as String,
          notes: eMap['notes'] as String,
          sets: sets,
        ));
      }

      workouts.add(WorkoutEntity(
        id: workoutId,
        name: wMap['name'] as String,
        date: wMap['date'] != null ? DateTime.parse(wMap['date'] as String) : null,
        duration: wMap['duration'] as int,
        notes: wMap['notes'] as String,
        isTemplate: (wMap['isTemplate'] as int) == 1,
        exercises: exercises,
      ));
    }

    return workouts;
  }

  @override
  Future<void> saveWorkout(WorkoutEntity workout) async {
    final db = await _dbProvider.database;

    await db.transaction((txn) async {
      // 1. Sauvegarder Workout (Insert OR Replace)
      await txn.insert(
        'workouts',
        {
          'id': workout.id,
          'name': workout.name,
          'date': workout.date?.toIso8601String(),
          'duration': workout.duration,
          'notes': workout.notes,
          'isTemplate': workout.isTemplate ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 2. Supprimer les anciens exercices/sets pour réécrire proprement
      // (Plus simple que de gérer les updates partiels)
      await txn.delete('workout_exercises', where: 'workoutId = ?', whereArgs: [workout.id]);
      
      // Note: CASCADE delete devrait nettoyer les sets, mais par sécurité avec Sqflite :
      // On insère les nouveaux

      for (var exercise in workout.exercises) {
        await txn.insert('workout_exercises', {
          'id': exercise.id,
          'workoutId': workout.id,
          'exerciseId': exercise.exerciseId,
          'exerciseName': exercise.exerciseName,
          'notes': exercise.notes,
        });

        for (var set in exercise.sets) {
          await txn.insert('sets', {
            'id': set.id,
            'workoutExerciseId': exercise.id,
            'setIndex': set.index,
            'weight': set.weight,
            'reps': set.reps,
            'isCompleted': set.isCompleted ? 1 : 0,
          });
        }
      }
    });
  }

  @override
  Future<void> deleteWorkout(String id) async {
    final db = await _dbProvider.database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }
}
