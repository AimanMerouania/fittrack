import 'package:flutter/material.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../../../core/widgets/glass_card.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseEntity exercise;
  final VoidCallback? onTap;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: exercise.gifUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const Icon(Icons.fitness_center, color: Colors.white54),
                  )
                : const Icon(Icons.fitness_center, color: Colors.white54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exercise.target} • ${exercise.equipment}',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exercise.isFavorite ? Theme.of(context).primaryColor : Colors.white24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
