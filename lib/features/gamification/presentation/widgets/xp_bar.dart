import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/gamification_cubit.dart';
import '../bloc/gamification_state.dart';

class XPBar extends StatelessWidget {
  const XPBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamificationCubit, GamificationState>(
      listener: (context, state) {
        if (state.hasLeveledUp) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('NIVEAU SUPÉRIEUR ! Bienvenue au niveau ${state.stats.level}'),
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final stats = state.stats;
        final double progress = (stats.currentXP / stats.maxXP).clamp(0.0, 1.0);

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NIVEAU ${stats.level}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    '${stats.currentXP} / ${stats.maxXP} XP',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  // Fond de la barre
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Barre de progression
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutExpo,
                        height: 8,
                        width: constraints.maxWidth * progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.5),
                              Theme.of(context).primaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.6),
                              blurRadius: 6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${stats.title} - Plus que ${stats.maxXP - stats.currentXP} XP !',
                style: const TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        );
      },
    );
  }
}
