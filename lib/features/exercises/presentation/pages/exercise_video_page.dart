import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/services/posture_correction_service.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/data/exercise_videos.dart';
import '../../domain/entities/exercise_entity.dart';

class ExerciseVideoPage extends StatefulWidget {
  final ExerciseEntity exercise;

  const ExerciseVideoPage({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseVideoPage> createState() => _ExerciseVideoPageState();
}

class _ExerciseVideoPageState extends State<ExerciseVideoPage> {
  final PostureCorrectionService _postureService = PostureCorrectionService();
  late YoutubePlayerController _youtubeController;
  bool _isAnalyzing = false;
  PostureAnalysis? _currentAnalysis;
  ExerciseVideoData? _videoData;

  @override
  void initState() {
    super.initState();
    _videoData = ExerciseVideos.getVideoForExercise(widget.exercise.name);

    if (_videoData != null) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: _videoData!.youtubeId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_videoData != null) {
      _youtubeController.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name.toUpperCase()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library_outlined,
                  size: 80, color: Colors.white38),
              const SizedBox(height: 16),
              Text(
                'Vidéo non disponible',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'pour cet exercice',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 80,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonBlue.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              title: Text(
                widget.exercise.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Lecteur YouTube
                _buildYoutubePlayer(),

                const SizedBox(height: 24),

                // Contrôles IA
                _buildAIControls(),

                const SizedBox(height: 24),

                // Analyse IA en temps réel
                if (_isAnalyzing) _buildPostureAnalysis(),

                const SizedBox(height: 24),

                // Description détaillée
                _buildDescription(),

                const SizedBox(height: 24),

                // Informations sur l'exercice
                _buildExerciseInfo(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYoutubePlayer() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Lecteur YouTube
            YoutubePlayer(
              controller: _youtubeController,
              aspectRatio: 16 / 9,
            ),

            // Overlay d'analyse IA
            if (_isAnalyzing && _currentAnalysis != null)
              Positioned(
                top: 16,
                right: 16,
                child: _buildScoreOverlay(),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildScoreOverlay() {
    final score = _currentAnalysis!.score;
    final color = score >= 90
        ? Colors.green
        : score >= 75
            ? Colors.orange
            : Colors.red;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            'IA: $score%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms);
  }

  Widget _buildAIControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isAnalyzing = !_isAnalyzing;
                });
              },
              icon: Icon(_isAnalyzing ? Icons.stop : Icons.psychology),
              label: Text(_isAnalyzing ? 'ARRÊTER L\'IA' : 'ACTIVER L\'IA'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isAnalyzing ? Colors.red : AppTheme.neonPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildPostureAnalysis() {
    return StreamBuilder<PostureAnalysis>(
      stream: _postureService.analyzePosture(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _currentAnalysis = snapshot.data;
        final analysis = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: AppTheme.neonPurple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ANALYSE IA EN TEMPS RÉEL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Score global
                _buildScoreBar(analysis.score),

                const SizedBox(height: 16),

                // Corrections
                ...analysis.corrections
                    .map((correction) => _buildCorrectionItem(correction)),
              ],
            ),
          ),
        ).animate().fadeIn().slideX(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildScoreBar(int score) {
    final color = score >= 90
        ? Colors.green
        : score >= 75
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Score de posture',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              '$score%',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 12,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectionItem(PostureCorrection correction) {
    final color = correction.severity == Severity.high
        ? Colors.red
        : correction.severity == Severity.medium
            ? Colors.orange
            : correction.severity == Severity.low
                ? Colors.yellow
                : Colors.green;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            correction.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              correction.message,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: AppTheme.neonGreen, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'DESCRIPTION DÉTAILLÉE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _videoData!.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildExerciseInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'INFORMATIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.fitness_center, 'Partie du corps',
                widget.exercise.bodyPart),
            _buildInfoRow(
                Icons.my_location, 'Muscle ciblé', widget.exercise.target),
            _buildInfoRow(Icons.build, 'Équipement', widget.exercise.equipment),
            _buildInfoRow(
                Icons.signal_cellular_alt, 'Niveau', widget.exercise.level),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neonBlue, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
