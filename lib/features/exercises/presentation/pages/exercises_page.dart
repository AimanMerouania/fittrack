import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_theme.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../bloc/exercise_bloc.dart';
import '../widgets/exercise_list_item.dart';
import 'exercise_detail_page.dart';
import 'exercise_creator_page.dart';

class ExercisesPage extends StatelessWidget {
  final bool isSelectionMode;

  const ExercisesPage({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseBloc(
        exerciseRepository: context.read<ExerciseRepository>(),
      )..add(ExerciseFetchStarted()),
      child: ExercisesView(isSelectionMode: isSelectionMode),
    );
  }
}

class ExercisesView extends StatelessWidget {
  final bool isSelectionMode;

  const ExercisesView({super.key, required this.isSelectionMode});

  void _openCreator(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ExerciseCreatorPage()),
    );

    if (result != null && context.mounted) {
      context.read<ExerciseBloc>().add(ExerciseAdded(result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exercice "${result.name}" créé avec succès!'),
          backgroundColor: AppTheme.neonGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppTheme.darkBackground,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                isSelectionMode ? 'CHOISIR' : 'EXERCICES',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.neonPurple.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un exercice...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: Show filter bottom sheet
                    },
                  ),
                ),
                onChanged: (value) {
                  context.read<ExerciseBloc>().add(
                        ExerciseSearchChanged(value),
                      );
                },
              ).animate().fadeIn().slideY(),
            ),
          ),

          // Exercise List
          BlocBuilder<ExerciseBloc, ExerciseState>(
            builder: (context, state) {
              switch (state.status) {
                case ExerciseStatus.failure:
                  return const SliverFillRemaining(
                    child: Center(child: Text('Erreur de chargement 😢')),
                  );
                case ExerciseStatus.success:
                  if (state.exercises.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade700),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun exercice trouvé',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _openCreator(context),
                              icon: const Icon(Icons.add),
                              label: const Text('CRÉER CET EXERCICE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.neonBlue,
                                foregroundColor: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final exercise = state.exercises[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ExerciseListItem(
                              exercise: exercise,
                              onTap: () {
                                if (isSelectionMode) {
                                  Navigator.of(context).pop(exercise);
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ExerciseDetailPage(exercise: exercise),
                                    ),
                                  );
                                }
                              },
                            ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1),
                          );
                        },
                        childCount: state.exercises.length,
                      ),
                    ),
                  );
                case ExerciseStatus.initial:
                case ExerciseStatus.loading:
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
              }
            },
          ),
        ],
      ),
      floatingActionButton: !isSelectionMode
          ? FloatingActionButton(
              onPressed: () => _openCreator(context),
              backgroundColor: AppTheme.neonBlue,
              foregroundColor: Colors.black,
              child: const Icon(Icons.add),
            ).animate().scale(delay: 500.ms)
          : null,
    );
  }
}
