import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';

class MockExerciseRepository implements ExerciseRepository {
  final List<ExerciseEntity> _allExercises = [
    const ExerciseEntity(
      id: '001',
      name: 'Push-up',
      bodyPart: 'chest',
      target: 'pectorals',
      equipment: 'body weight',
      gifUrl: 'https://v2.exercisedb.io/image/3e4g5h6j',
      level: 'beginner',
      instructions: [
        'Placez vos mains au sol, écartées de la largeur des épaules.',
        'Gardez le corps droit, gainé.',
        'Descendez jusqu\'à ce que votre poitrine frôle le sol.',
        'Remontez en position initiale.'
      ],
    ),
    const ExerciseEntity(
      id: '002',
      name: 'Squat',
      bodyPart: 'legs',
      target: 'quads',
      equipment: 'body weight',
      gifUrl: '',
      level: 'beginner',
      instructions: [
        'Pieds écartés largeur d\'épaules.',
        'Descendez les fesses en arrière comme pour vous asseoir.',
        'Gardez le dos droit.',
        'Remontez en poussant sur les talons.'
      ],
    ),
    const ExerciseEntity(
      id: '003',
      name: 'Pull-up',
      bodyPart: 'back',
      target: 'lats',
      equipment: 'body weight',
      gifUrl: '',
      isFavorite: true,
      level: 'intermediate',
      instructions: ['Suspendez-vous à la barre.', 'Tirez jusqu\'au menton.'],
    ),
    const ExerciseEntity(
      id: '004',
      name: 'Dumbbell Curl',
      bodyPart: 'arms',
      target: 'biceps',
      equipment: 'dumbbell',
      gifUrl: '',
    ),
    const ExerciseEntity(
      id: '005',
      name: 'Plank',
      bodyPart: 'core',
      target: 'abs',
      equipment: 'body weight',
      gifUrl: '',
    ),
    const ExerciseEntity(
      id: '006',
      name: 'Bench Press',
      bodyPart: 'chest',
      target: 'pectorals',
      equipment: 'barbell',
      gifUrl: '',
    ),
  ];

  @override
  Future<List<ExerciseEntity>> getExercises({int limit = 20, int offset = 0}) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simuler latence
    return _allExercises;
  }

  @override
  Future<List<ExerciseEntity>> getExercisesByBodyPart(String bodyPart) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allExercises.where((e) => e.bodyPart == bodyPart).toList();
  }

  @override
  Future<List<ExerciseEntity>> searchExercises(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _allExercises.where((e) => 
      e.name.toLowerCase().contains(lowerQuery) || 
      e.target.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  @override
  Future<void> toggleFavorite(String exerciseId) async {
    // Dans un vrai repo, on persisterait ça en DB locale
    // Ici on ne fait rien car c'est un mock stateless pour l'instant
    return;
  }

  @override
  Future<void> addExercise(ExerciseEntity exercise) async {
    _allExercises.add(exercise);
  }
}
