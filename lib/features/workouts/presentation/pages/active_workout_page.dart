import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/themes/app_theme.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/repositories/workout_repository.dart';
import '../bloc/active_workout_cubit.dart';
import '../../../gamification/presentation/bloc/gamification_cubit.dart';
import 'workout_summary_page.dart';

class ActiveWorkoutPage extends StatelessWidget {
  final WorkoutEntity template;

  const ActiveWorkoutPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActiveWorkoutCubit(
        repository: context.read<WorkoutRepository>(),
        template: template,
      ),
      child: const ActiveWorkoutView(),
    );
  }
}



class ActiveWorkoutView extends StatelessWidget {
  const ActiveWorkoutView({super.key});

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveWorkoutCubit, ActiveWorkoutState>(
      listener: (context, state) {
        if (state.status == ActiveWorkoutStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => WorkoutSummaryPage(
                workout: state.workout,
                durationSeconds: state.elapsedSeconds,
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  const Color(0xFF1A1A1A),
                  AppTheme.neonBlue.withOpacity(0.05),
                ],
              ),
            ),
          ),
          
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
                buildWhen: (p, c) => p.elapsedSeconds != c.elapsedSeconds,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.workout.name.toUpperCase(),
                          style: const TextStyle(fontSize: 14, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 12, color: AppTheme.neonGreen),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(state.elapsedSeconds),
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.neonGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton.icon(
                    onPressed: () => _showFinishDialog(context),
                    icon: const Icon(Icons.flag, color: Colors.white),
                    label: const Text('TERMINER', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
            body: BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  itemCount: state.workout.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = state.workout.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Exercice
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                border: const Border(bottom: BorderSide(color: Colors.white10)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.neonBlue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.fitness_center, color: AppTheme.neonBlue, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      exercise.exerciseName,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: Colors.white54),
                                    onPressed: () {
                                      // TODO: Show exercise info
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            // Sets List
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Headers
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 30, child: Text('#', style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold))),
                                        Expanded(child: Center(child: Text('KG', style: TextStyle(color: AppTheme.neonBlue.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 12)))),
                                        const SizedBox(width: 16),
                                        Expanded(child: Center(child: Text('REPS', style: TextStyle(color: AppTheme.neonPurple.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 12)))),
                                        const SizedBox(width: 40, child: Center(child: Icon(Icons.check, size: 16, color: Colors.white30))),
                                      ],
                                    ),
                                  ),
                                  
                                  ...List.generate(exercise.sets.length, (setIndex) {
                                    final set = exercise.sets[setIndex];
                                    final isCompleted = set.isCompleted;
                                    
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isCompleted ? AppTheme.neonGreen.withOpacity(0.1) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: isCompleted 
                                            ? Border.all(color: AppTheme.neonGreen.withOpacity(0.3))
                                            : null
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 30, 
                                            child: Container(
                                              width: 24, height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(child: Text('${set.index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                            ),
                                          ),
                                          
                                          // KG Input
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.white10),
                                              ),
                                              child: TextFormField(
                                                initialValue: set.weight.toString(),
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) => context.read<ActiveWorkoutCubit>()
                                                    .updateSet(exercise.id, setIndex, weight: double.tryParse(val)),
                                              ),
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 8),

                                          // REPS Input
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.white10),
                                              ),
                                              child: TextFormField(
                                                initialValue: set.reps.toString(),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) => context.read<ActiveWorkoutCubit>()
                                                    .updateSet(exercise.id, setIndex, reps: int.tryParse(val)),
                                              ),
                                            ),
                                          ),

                                          // Checkbox custom
                                          SizedBox(
                                            width: 48,
                                            child: Center(
                                              child: InkWell(
                                                onTap: () => context.read<ActiveWorkoutCubit>().toggleSetInitial(exercise.id, setIndex),
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  width: 32, height: 32,
                                                  decoration: BoxDecoration(
                                                    color: isCompleted ? AppTheme.neonGreen : Colors.white.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: isCompleted ? [
                                                      BoxShadow(color: AppTheme.neonGreen.withOpacity(0.5), blurRadius: 8)
                                                    ] : [],
                                                  ),
                                                  child: Icon(
                                                    Icons.check, 
                                                    size: 20, 
                                                    color: isCompleted ? Colors.black : Colors.white24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Overlay Rest Timer (Premium)
          BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
            buildWhen: (p, c) => p.restTimerSeconds != c.restTimerSeconds,
            builder: (context, state) {
              if (state.restTimerSeconds <= 0) return const SizedBox.shrink();
              
              return Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                       BoxShadow(
                        color: Colors.amber.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                       Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           color: Colors.amber.withOpacity(0.2),
                           shape: BoxShape.circle,
                           border: Border.all(color: Colors.amber.withOpacity(0.5)),
                         ),
                         child: const Icon(Icons.timer, color: Colors.amber, size: 24),
                       ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('TEMPS DE REPOS', 
                            style: TextStyle(color: Colors.amber, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                          Text(
                            _formatDuration(state.restTimerSeconds).substring(3),
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _RestControlBtn(
                        icon: Icons.add,
                        label: "+30s",
                        onTap: () => context.read<ActiveWorkoutCubit>().addRestTime(30),
                      ),
                      const SizedBox(width: 12),
                      _RestControlBtn(
                        icon: Icons.close,
                        label: "Skip",
                        onTap: () => context.read<ActiveWorkoutCubit>().cancelRestTimer(),
                        isSecondary: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white.withOpacity(0.1))),
        title: const Text('Terminer la séance ?', style: TextStyle(color: Colors.white)),
        content: const Text(
            'Assure-toi d\'avoir coché toutes tes séries réalisées. Le reste sera considéré comme non fait.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ANNULER', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ActiveWorkoutCubit>().finishWorkout();
              context.read<GamificationCubit>().addXP(150); // +150 XP Reward
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen, foregroundColor: Colors.black),
            child: const Text('TERMINER & SAUVEGARDER'),
          ),
        ],
      ),
    );
  }
}

class _RestControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;

  const _RestControlBtn({required this.icon, required this.label, required this.onTap, this.isSecondary = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSecondary ? Colors.white.withOpacity(0.05) : Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSecondary ? Colors.white10 : Colors.amber.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: isSecondary ? Colors.white70 : Colors.amber),
            Text(label, style: TextStyle(fontSize: 10, color: isSecondary ? Colors.white70 : Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
