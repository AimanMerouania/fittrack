import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/workout_repository.dart';
import '../bloc/workout_editor_cubit.dart';
import '../../../exercises/presentation/pages/exercises_page.dart';
import '../../../exercises/domain/entities/exercise_entity.dart';

class WorkoutCreatorPage extends StatelessWidget {
  const WorkoutCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutEditorCubit(
        repository: context.read<WorkoutRepository>(),
      ),
      child: const WorkoutCreatorView(),
    );
  }
}

class WorkoutCreatorView extends StatelessWidget {
  const WorkoutCreatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutEditorCubit, WorkoutEditorState>(
      listener: (context, state) {
        if (state.status == WorkoutEditorStatus.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Programme sauvegardé ! 🏋️‍♂️')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nouveau Programme'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context.read<WorkoutEditorCubit>().saveWorkout();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Nom du programme',
                  hintText: 'ex: Pectoraux Lundi',
                  prefixIcon: Icon(Icons.edit),
                ),
                onChanged: (value) =>
                    context.read<WorkoutEditorCubit>().nameChanged(value),
              ),
            ),
             Expanded(
              child: BlocBuilder<WorkoutEditorCubit, WorkoutEditorState>(
                builder: (context, state) {
                  if (state.exercises.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fitness_center_outlined,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text('Ajoutez votre premier exercice',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.exercises.length,
                    itemBuilder: (context, index) {
                      final workoutExercise = state.exercises[index];
                      // Ici on pourrait faire un widget dédié complexe pour gérer les sets
                      // Pour l'instant on fait simple
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(workoutExercise.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                               const SizedBox(height: 8),
                               ...workoutExercise.sets.map((set) => Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 4),
                                 child: Row(
                                   children: [
                                     Text('Set ${set.index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                     const SizedBox(width: 16),
                                     Expanded(child: Text('${set.reps} reps')), // Placeholder visual
                                     // TODO: Add inputs for Set editing
                                   ],
                                 ),
                               )).toList(),
                               TextButton.icon(
                                 icon: const Icon(Icons.add),
                                 label: const Text('Ajouter une série'),
                                 onPressed: () => context.read<WorkoutEditorCubit>().addSet(workoutExercise.id),
                               )
                             ],
                           ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final ExerciseEntity? selectedExercise = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ExercisesPage(isSelectionMode: true),
              ),
            );

            if (selectedExercise != null && context.mounted) {
              context.read<WorkoutEditorCubit>().addExercise(selectedExercise);
            }
          },
          label: const Text('Ajouter Exercice'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
