import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:formz/formz.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/themes/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Avoid pixel overflow on keyboard
      body: Stack(
        children: [
          // 1. Animated Background
          const _AnimatedBackground(),

          // 2. Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status.isFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage ?? 'Authentication Failure'),
                          backgroundColor: AppTheme.errorRed,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Hero
                    const Hero(
                      tag: 'app_logo',
                      child: Icon(Icons.fitness_center, size: 80, color: AppTheme.neonGreen),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scaleXY(begin: 1, end: 1.1, duration: 2000.ms, curve: Curves.easeInOut),
                    
                    const SizedBox(height: 16),
                    
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 40, fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                        children: [
                          const TextSpan(text: 'FIT'),
                          TextSpan(text: 'TRACK', style: TextStyle(color: AppTheme.neonGreen)),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5),

                    const SizedBox(height: 8),
                    
                    Text(
                      'BECOME UNSTOPPABLE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 3,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 60),
                    
                    // Glass Form
                    GlassCard(
                      padding: const EdgeInsets.all(32),
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _EmailInput(),
                          const SizedBox(height: 20),
                          _PasswordInput(),
                          const SizedBox(height: 32),
                          _LoginButton(),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),

                    const SizedBox(height: 32),
                    
                    _SignUpButton().animate().fadeIn(delay: 900.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.darkBackground,
      ),
      child: Stack(
        children: [
          // Orb 1
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(
                    50 * math.cos(_controller.value * 2 * math.pi),
                    50 * math.sin(_controller.value * 2 * math.pi),
                  ),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [AppTheme.neonBlue.withOpacity(0.2), Colors.transparent],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Orb 2
          Positioned(
            bottom: -50,
            left: -50,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(
                    30 * math.sin(_controller.value * 2 * math.pi),
                    30 * math.cos(_controller.value * 2 * math.pi),
                  ),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [AppTheme.neonPurple.withOpacity(0.15), Colors.transparent],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
            errorText: state.status.isFailure ? 'Email invalide' : null,
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.neonBlue),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Mot de passe',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
            errorText: state.status.isFailure ? 'Mot de passe invalide' : null,
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.neonBlue),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator(color: AppTheme.neonGreen))
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: AppTheme.neonGreen.withOpacity(0.4),
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: const Text(
                    'SE CONNECTER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
         // Switch to signup
         ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription bientôt disponible !')),
            );
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white70),
          children: [
            const TextSpan(text: 'Pas encore de compte ? '),
            TextSpan(
              text: 'S\'inscrire',
              style: TextStyle(
                color: AppTheme.neonBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
