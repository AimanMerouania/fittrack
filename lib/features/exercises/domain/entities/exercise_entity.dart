import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String bodyPart;    // ex: chest, back, legs
  final String target;      // ex: pectorals, lats
  final String equipment;   // ex: body weight, dumbbell
  final String gifUrl;      // URL de l'image/animation
  final List<String> instructions; // Liste des étapes
  final String level;       // beginner, intermediate, expert
  final bool isFavorite;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.gifUrl,
    this.instructions = const [],
    this.level = 'beginner',
    this.isFavorite = false,
  });

  ExerciseEntity copyWith({
    bool? isFavorite,
  }) {
    return ExerciseEntity(
      id: id,
      name: name,
      bodyPart: bodyPart,
      target: target,
      equipment: equipment,
      gifUrl: gifUrl,
      instructions: instructions,
      level: level,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, name, bodyPart, target, equipment, gifUrl, instructions, level, isFavorite];
}
