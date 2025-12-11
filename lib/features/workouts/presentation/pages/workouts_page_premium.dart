import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/repositories/workout_repository.dart';
import '../bloc/workouts_list_cubit.dart';
import '../pages/workout_creator_page.dart';
import 'active_workout_page.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/themes/app_theme.dart';

class WorkoutsPagePremium extends StatelessWidget {
  const WorkoutsPagePremium({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutsListCubit(
        context.read<WorkoutRepository>(),
      )..loadWorkouts(),
      child: const WorkoutsViewPremium(),
    );
  }
}

class WorkoutsViewPremium extends StatefulWidget {
  const WorkoutsViewPremium({super.key});

  @override
  State<WorkoutsViewPremium> createState() => _WorkoutsViewPremiumState();
}

class _WorkoutsViewPremiumState extends State<WorkoutsViewPremium> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Force',
    'Cardio',
    'Full Body',
    'Split'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'MES PROGRAMMES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.neonBlue.withOpacity(0.3),
                          AppTheme.neonPurple.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.neonBlue.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Statistics Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<WorkoutsListCubit, WorkoutsListState>(
                builder: (context, state) {
                  final totalWorkouts = state.workouts.length;
                  final totalExercises = state.workouts.fold<int>(
                    0,
                    (sum, workout) => sum + workout.exercises.length,
                  );

                  return Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.fitness_center,
                          value: totalWorkouts.toString(),
                          label: 'Programmes',
                          color: AppTheme.neonBlue,
                        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.list_alt,
                          value: totalExercises.toString(),
                          label: 'Exercices',
                          color: AppTheme.neonPurple,
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department,
                          value: '${totalWorkouts * 45}',
                          label: 'Min/Sem',
                          color: Colors.orangeAccent,
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Category Filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(category),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.grey.shade900,
                      selectedColor: AppTheme.neonBlue.withOpacity(0.3),
                      checkmarkColor: AppTheme.neonBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.neonBlue : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.neonBlue
                            : Colors.grey.shade800,
                      ),
                    ).animate(target: isSelected ? 1 : 0).scale(
                          duration: 200.ms,
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                        ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 400.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Workouts List
          BlocBuilder<WorkoutsListCubit, WorkoutsListState>(
            builder: (context, state) {
              switch (state.status) {
                case WorkoutsListStatus.failure:
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Erreur de chargement'),
                        ],
                      ),
                    ),
                  );
                case WorkoutsListStatus.success:
                  if (state.workouts.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: AppTheme.neonBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: AppTheme.neonBlue,
                              ),
                            )
                                .animate()
                                .scale(duration: 600.ms)
                                .then()
                                .shimmer(),
                            const SizedBox(height: 24),
                            const Text(
                              'Aucun programme',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Créez votre premier programme d\'entraînement',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final workout = state.workouts[index];
                          return _PremiumWorkoutCard(
                            workout: workout,
                            index: index,
                          );
                        },
                        childCount: state.workouts.length,
                      ),
                    ),
                  );
                case WorkoutsListStatus.initial:
                case WorkoutsListStatus.loading:
                default:
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
              }
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WorkoutCreatorPage()),
          );
          if (context.mounted) {
            context.read<WorkoutsListCubit>().loadWorkouts();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('NOUVEAU'),
        backgroundColor: AppTheme.neonBlue,
        foregroundColor: Colors.black,
      ).animate().fadeIn(delay: 500.ms).slideY(begin: 1),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumWorkoutCard extends StatelessWidget {
  final dynamic workout;
  final int index;

  const _PremiumWorkoutCard({
    required this.workout,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseCount = workout.exercises.length;
    final estimatedDuration = exerciseCount * 5; // 5 min per exercise estimate

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActiveWorkoutPage(template: workout),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getGradientColor(index).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getGradientColor(index).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getGradientColor(index).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _getWorkoutIcon(index),
                    color: _getGradientColor(index),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$exerciseCount exercices',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '~$estimatedDuration min',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getGradientColor(index).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: _getGradientColor(index),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Exercise Preview
          if (exerciseCount > 0)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getGradientColor(index),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EXERCICES',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...workout.exercises.take(3).map<Widget>((exercise) {
                    final sets = exercise.sets.length;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getGradientColor(index).withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              exercise.exerciseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$sets séries',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (exerciseCount > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${exerciseCount - 3} autres exercices',
                        style: TextStyle(
                          color: _getGradientColor(index),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
  }

  Color _getGradientColor(int index) {
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
    ];
    return colors[index % colors.length];
  }

  IconData _getWorkoutIcon(int index) {
    final icons = [
      Icons.fitness_center,
      Icons.sports_gymnastics,
      Icons.sports_martial_arts,
      Icons.self_improvement,
      Icons.sports_kabaddi,
    ];
    return icons[index % icons.length];
  }
}
