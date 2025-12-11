import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/share_service.dart';
import '../../domain/entities/workout_entity.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WorkoutSummaryPage extends StatefulWidget {
  final WorkoutEntity workout;
  final int durationSeconds;

  const WorkoutSummaryPage({
    super.key,
    required this.workout,
    required this.durationSeconds,
  });

  @override
  State<WorkoutSummaryPage> createState() => _WorkoutSummaryPageState();
}

class _WorkoutSummaryPageState extends State<WorkoutSummaryPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}h ${twoDigits(duration.inMinutes.remainder(60))}m";
  }

  int get _totalVolume {
    int volume = 0;
    for (var exercise in widget.workout.exercises) {
      for (var set in exercise.sets) {
        if (set.isCompleted) {
          volume += (set.weight * set.reps).round();
        }
      }
    }
    return volume;
  }

  int get _totalSets {
    int sets = 0;
    for (var exercise in widget.workout.exercises) {
      sets += exercise.sets.where((s) => s.isCompleted).length;
    }
    return sets;
  }

  Future<void> _shareSummary() async {
    setState(() => _isSharing = true);
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        await getIt<ShareService>().shareImage(
          image,
          "J'ai terminé ma séance ${widget.workout.name} sur FitTrack ! 💪 #Fitness #FitTrack",
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible de partager l'image")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                const Color(0xFF1A1A1A),
                AppTheme.neonPurple.withOpacity(0.1),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Screenshot(
                  controller: _screenshotController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassCard(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.neonGreen.withOpacity(0.1),
                              border: Border.all(color: AppTheme.neonGreen.withOpacity(0.5), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonGreen.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                )
                              ]
                            ),
                            child: const Icon(Icons.emoji_events,
                                    size: 48, color: AppTheme.neonGreen)
                                .animate()
                                .scale(duration: 600.ms, curve: Curves.elasticOut),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            widget.workout.name.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.neonGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.neonGreen.withOpacity(0.3)),
                            ),
                            child: Text(
                              "SESSION TERMINÉE",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppTheme.neonGreen,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          
                          // Stats Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                Icons.timer_outlined,
                                _formatDuration(widget.durationSeconds),
                                "DURÉE",
                                AppTheme.neonBlue,
                              ),
                              Container(width: 1, height: 40, color: Colors.white10),
                              _buildStatItem(
                                context,
                                Icons.fitness_center,
                                "${_totalVolume}kg",
                                "VOLUME",
                                AppTheme.neonPurple,
                              ),
                              Container(width: 1, height: 40, color: Colors.white10),
                              _buildStatItem(
                                context,
                                Icons.repeat,
                                "$_totalSets",
                                "SÉRIES",
                                AppTheme.neonOrange,
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          // Branding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bolt,
                                  size: 16, color: Colors.white.withOpacity(0.3)),
                              const SizedBox(width: 8),
                              Text(
                                "FITTRACK",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().moveY(begin: 50, end: 0),
                ),
                const Spacer(),
                
                // Buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                            backgroundColor: Colors.white.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text("ACCUEIL",
                              style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonGreen.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ]
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _isSharing ? null : _shareSummary,
                            icon: _isSharing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : const Icon(Icons.share, color: Colors.black),
                            label: Text(_isSharing ? "..." : "PARTAGER"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.neonGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      BuildContext context, IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.8), size: 28),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
