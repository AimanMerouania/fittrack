import '../entities/workout_entity.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutEntity>> getWorkouts({bool templatesOnly = false});
  Future<void> saveWorkout(WorkoutEntity workout);
  Future<void> deleteWorkout(String id);
}
