import '../entities/exercise_entity.dart';

abstract class ExerciseRepository {
  /// Récupère la liste de tous les exercices (avec pagination potentielle)
  Future<List<ExerciseEntity>> getExercises({int limit = 20, int offset = 0});

  /// Recherche des exercices par nom
  Future<List<ExerciseEntity>> searchExercises(String query);

  /// Filtre par partie du corps (ex: 'chest')
  Future<List<ExerciseEntity>> getExercisesByBodyPart(String bodyPart);

  /// Ajoute/Enlève des favoris
  Future<void> toggleFavorite(String exerciseId);

  /// Ajoute un exercice personnalisé
  Future<void> addExercise(ExerciseEntity exercise);
}
