import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../exercises/presentation/pages/exercises_page.dart';
import '../../../workouts/presentation/pages/workouts_page_premium.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/fade_in.dart';
import '../../../gamification/presentation/widgets/xp_bar.dart';
import '../../../stats/presentation/pages/stats_page.dart';
import '../../../calendar/presentation/pages/calendar_page.dart';
import '../../../../core/themes/app_theme.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Info user
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      extendBodyBehindAppBar: true, // Pour que le fond passe derrière
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('FIT',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2)),
            Text('TRACK',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 2)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Effet de fond subtil (gradient très sombre)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F0F), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                  delay: 200,
                  child: Text(
                    'Bonjour, ${(user.displayName != null && user.displayName!.isNotEmpty) ? user.displayName! : 'Athlète'}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeIn(
                  delay: 400,
                  child: Text(
                    'PRÊT À\nTOUT CASSER ? 🔥',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          height: 1.0,
                          fontSize: 42,
                        ),
                  ),
                ),
                const SizedBox(height: 24),
                // Gamification XP
                const FadeIn(
                  delay: 500,
                  child: XPBar(),
                ),
                const SizedBox(height: 32),

                // Grille de navigation
                FadeIn(
                  delay: 600,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      _HomeGridItem(
                        icon: Icons.fitness_center,
                        label: 'EXERCICES',
                        count: 'bibliothèque',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ExercisesPage()),
                          );
                        },
                      ),
                      _HomeGridItem(
                        icon: Icons.bolt,
                        label: 'PROGRAMME',
                        count: 'Mes séances',
                        color: Theme.of(context).primaryColor, // Neon Green
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const WorkoutsPagePremium()),
                          );
                        },
                      ),
                      _HomeGridItem(
                        icon: Icons.calendar_month,
                        label: 'CALENDRIER',
                        count: 'Planning',
                        color: AppTheme.neonPurple,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const CalendarPage()),
                          );
                        },
                      ),
                      _HomeGridItem(
                        icon: Icons.bar_chart,
                        label: 'STATS',
                        count: 'Progression',
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const StatsPage()),
                          );
                        },
                      ),
                      _HomeGridItem(
                        icon: Icons.person,
                        label: 'PROFIL',
                        count: 'Paramètres',
                        color: Colors.tealAccent,
                        onTap: () {
                           Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ProfilePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;
  final VoidCallback onTap;

  const _HomeGridItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero, // Géré par la grille
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
