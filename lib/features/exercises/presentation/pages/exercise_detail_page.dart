import 'package:flutter/material.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../../core/themes/app_theme.dart';
import 'exercise_video_page.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exercise.name.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Exercise image from assets or network
                  _buildExerciseImage(exercise),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  FadeIn(
                    delay: 100,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        _TagChip(
                            label: exercise.bodyPart.toUpperCase(),
                            color: Colors.blueAccent),
                        _TagChip(
                            label: exercise.target.toUpperCase(),
                            color: Colors.purpleAccent),
                        _TagChip(
                            label: exercise.level.toUpperCase(),
                            color: _getLevelColor(exercise.level)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bouton Vidéo + IA (NOUVEAU)
                  FadeIn(
                    delay: 150,
                    child: _buildVideoButton(context),
                  ),
                  const SizedBox(height: 24),

                  // Instructions
                  const FadeIn(
                    delay: 200,
                    child: Text(
                      'INSTRUCTIONS',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Liste étapes
                  if (exercise.instructions.isEmpty)
                    const Text('Aucune instruction disponible.',
                        style: TextStyle(color: Colors.white30))
                  else
                    ...List.generate(exercise.instructions.length, (index) {
                      return FadeIn(
                        delay: 300 + (index * 100),
                        child: GlassCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text('${index + 1}',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold))),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Text(exercise.instructions[index],
                                      style: const TextStyle(
                                          color: Colors.white, height: 1.4))),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseImage(ExerciseEntity exercise) {
    final assetPath = _getExerciseAssetPath(exercise);

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to network image if asset fails
          if (exercise.gifUrl.isNotEmpty) {
            return Image.network(
              exercise.gifUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            );
          }
          return _buildPlaceholder();
        },
      );
    } else if (exercise.gifUrl.isNotEmpty) {
      return Image.network(
        exercise.gifUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade900,
      child: const Icon(Icons.fitness_center, size: 100, color: Colors.white12),
    );
  }

  String? _getExerciseAssetPath(ExerciseEntity exercise) {
    final name = exercise.name.toLowerCase();

    // Map common exercise names to asset paths
    if (name.contains('bench') && name.contains('press')) {
      return 'assets/images/exercises/bench_press.png';
    } else if (name.contains('squat')) {
      return 'assets/images/exercises/squat.png';
    } else if (name.contains('deadlift')) {
      return 'assets/images/exercises/deadlift.png';
    } else if (name.contains('pull') &&
        (name.contains('up') || name.contains('chin'))) {
      return 'assets/images/exercises/pullup.png';
    } else if (name.contains('shoulder') && name.contains('press') ||
        name.contains('overhead') && name.contains('press') ||
        name.contains('military') && name.contains('press')) {
      return 'assets/images/exercises/shoulder_press.png';
    }

    return null;
  }

  Widget _buildVideoButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.neonPurple.withOpacity(0.3),
            AppTheme.neonBlue.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonPurple.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseVideoPage(exercise: exercise),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.neonPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.play_circle_filled,
                    color: AppTheme.neonPurple,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'VIDÉO TUTORIEL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.neonGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'IA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Correction de posture en temps réel',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.neonPurple,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.greenAccent;
      case 'intermediate':
        return Colors.orangeAccent;
      case 'expert':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
