// ... (imports remain)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../workouts/domain/repositories/workout_repository.dart';
import '../bloc/stats_cubit.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsCubit(context.read<WorkoutRepository>())..loadStats(),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STATISTIQUES')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VOLUME HEBDOMADAIRE (Derniers 7 jours)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white70),
            ).animate().fadeIn(),
            const SizedBox(height: 16),
            const SizedBox(
              height: 250,
              child: _NeonLineChart(),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 32),
            const Text(
              'ÉQUILIBRE MUSCULAIRE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white70),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            const _MuscleDistributionSection().animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 32),
            const Text(
              'HISTORIQUE RÉCENT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white70),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 16),
            BlocBuilder<StatsCubit, StatsState>(
              builder: (context, state) {
                if (state.status == StatsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.history.isEmpty) {
                  return const Center(child: Text('Aucune séance terminée.', style: TextStyle(color: Colors.white30)));
                }
                return Column(
                  children: state.history.reversed.take(5).map((workout) {
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workout.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(
                                '${workout.exercises.length} exercices • ${workout.duration ~/ 60} min',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                          const Icon(Icons.check_circle, color: AppTheme.neonGreen),
                        ],
                      ),
                    ).animate().slideX(begin: 0.2, curve: Curves.easeOut);
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12, height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)]),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _NeonLineChart extends StatelessWidget {
  const _NeonLineChart();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        // Map weeklyVolume List<int> to List<FlSpot>
        final spots = state.weeklyVolume.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.toDouble());
        }).toList();

        final maxY = (state.weeklyVolume.isNotEmpty 
            ? state.weeklyVolume.reduce((a, b) => a > b ? a : b) + 2
            : 5).toDouble();

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.white.withOpacity(0.05),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(days[value.toInt()], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                isCurved: true,
                color: AppTheme.neonBlue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.neonBlue.withOpacity(0.3),
                      AppTheme.neonBlue.withOpacity(0.0),
                    ],
                  ),
                ),
                shadow: Shadow(
                  color: AppTheme.neonBlue.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MuscleDistributionSection extends StatelessWidget {
  const _MuscleDistributionSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state.muscleDistribution.isEmpty) {
          return const Center(child: Text('Pas assez de données', style: TextStyle(color: Colors.white30)));
        }

        final colors = [Colors.blue, Colors.purple, Colors.orange, Colors.green, Colors.teal];
        int colorIndex = 0;

        final sections = state.muscleDistribution.entries.map((e) {
          final color = colors[colorIndex % colors.length];
          colorIndex++;
          return PieChartSectionData(
            color: color, 
            value: e.value.toDouble(), 
            title: '${e.value}', 
            radius: 25, 
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
          );
        }).toList();

        return Row(
          children: [
             Expanded(
               child: AspectRatio(
                 aspectRatio: 1,
                 child: PieChart(
                   PieChartData(
                     sectionsSpace: 2,
                     centerSpaceRadius: 40,
                     sections: sections,
                   ),
                 ),
               ),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: state.muscleDistribution.keys.toList().asMap().entries.map((e) {
                   return _LegendItem(
                     color: colors[e.key % colors.length], 
                     label: e.value
                   );
                 }).toList(),
               ),
             )
          ],
        );
      },
    );
  }
}
