import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/workout_repository.dart';
import '../bloc/workouts_list_cubit.dart';
import '../pages/workout_creator_page.dart';
import 'active_workout_page.dart';
import '../../../../core/widgets/glass_card.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutsListCubit(
        context.read<WorkoutRepository>(),
      )..loadWorkouts(),
      child: const WorkoutsView(),
    );
  }
}

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Programmes'),
      ),
      body: BlocBuilder<WorkoutsListCubit, WorkoutsListState>(
        builder: (context, state) {
          switch (state.status) {
            case WorkoutsListStatus.failure:
              return const Center(child: Text('Erreur de chargement'));
            case WorkoutsListStatus.success:
              if (state.workouts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.fitness_center,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('Aucun programme trouvé',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.workouts.length,
                itemBuilder: (context, index) {
                  final workout = state.workouts[index];
                  return GlassCard(
                    onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ActiveWorkoutPage(template: workout),
                          ),
                        );
                    },
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workout.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('${workout.exercises.length} exercices', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        ),
                         Icon(Icons.play_circle_fill, color: Theme.of(context).colorScheme.primary, size: 32),
                      ],
                    ),
                  );
                },
              );
            case WorkoutsListStatus.initial:
            case WorkoutsListStatus.loading:
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WorkoutCreatorPage()),
          );
          // Recharger la liste au retour
          context.read<WorkoutsListCubit>().loadWorkouts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
