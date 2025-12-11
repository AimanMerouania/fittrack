import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('PROFIL'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres avancés bientôt disponibles !')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.darkBackground,
              AppTheme.neonBlue.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar & Info
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.neonBlue, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonBlue.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                              image: const DecorationImage(
                                image: NetworkImage('https://i.pravatar.cc/300'), // Mock Avatar
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.neonGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 16),
                      Text(
                        (user.displayName != null && user.displayName!.isNotEmpty) 
                            ? user.displayName! 
                            : 'Athlète FitTrack',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.5),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.neonPurple.withOpacity(0.5)),
                        ),
                        child: const Text(
                          'Niveau 5 - Titan',
                          style: TextStyle(
                            color: AppTheme.neonPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.5),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Stats Row
                Row(
                  children: [
                    Expanded(child: _ProfileStat(value: '12', label: 'Séances', color: AppTheme.neonBlue)),
                    const SizedBox(width: 16),
                    Expanded(child: _ProfileStat(value: '4h30', label: 'Temps', color: Colors.orange)),
                    const SizedBox(width: 16),
                    Expanded(child: _ProfileStat(value: '350', label: 'XP', color: AppTheme.neonGreen)),
                  ],
                ).animate().fadeIn(delay: 200.ms).slideX(),

                const SizedBox(height: 32),

                // Settings Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PRÉFÉRENCES',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: true,
                        onChanged: (val) {},
                        activeColor: AppTheme.neonBlue,
                        title: const Text('Mode Sombre', style: TextStyle(color: Colors.white)),
                        secondary: const Icon(Icons.dark_mode, color: Colors.white70),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      SwitchListTile(
                        value: true,
                        onChanged: (val) {},
                        activeColor: AppTheme.neonBlue,
                        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
                        secondary: const Icon(Icons.notifications, color: Colors.white70),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      ListTile(
                        title: const Text('Langue', style: TextStyle(color: Colors.white)),
                        leading: const Icon(Icons.language, color: Colors.white70),
                        trailing: const Text('Français', style: TextStyle(color: Colors.white54)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                      Navigator.of(context).pop(); // Go back to home wrapper which will show login
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('SE DÉCONNECTER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed.withOpacity(0.1),
                      foregroundColor: AppTheme.errorRed,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.errorRed),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),
                
                const SizedBox(height: 16),
                 Text(
                  'Version 1.0.0 - Beta',
                  style: TextStyle(color: Colors.white.withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ProfileStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
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
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white54,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
