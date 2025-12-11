/// Base de données des vidéos YouTube pour chaque exercice
class ExerciseVideos {
  static const Map<String, ExerciseVideoData> videos = {
    // Exercices de poitrine
    'bench press': ExerciseVideoData(
      youtubeId: 'gRVjAtPip0Y', // Vidéo de démonstration Bench Press
      title: 'Comment faire le Développé Couché (Bench Press)',
      description: '''
Le développé couché est l'exercice roi pour développer les pectoraux.

**Points Clés:**
• Gardez les pieds bien ancrés au sol
• Descendez la barre jusqu'à la poitrine
• Gardez les coudes à 45° du corps
• Poussez de manière explosive
• Respirez: inspirez en descendant, expirez en montant

**Muscles Travaillés:**
• Pectoraux (principal)
• Triceps (secondaire)
• Deltoïdes antérieurs (secondaire)

**Erreurs Communes:**
❌ Décoller les fesses du banc
❌ Rebondir la barre sur la poitrine
❌ Bloquer les coudes en haut
❌ Écarter trop les coudes
''',
    ),

    'incline bench press': ExerciseVideoData(
      youtubeId: 'SrqOu55lrYU',
      title: 'Développé Incliné - Technique Parfaite',
      description: '''
Le développé incliné cible la partie haute des pectoraux.

**Points Clés:**
• Inclinaison du banc: 30-45°
• Même technique que le développé couché
• Focus sur la contraction du haut des pecs
• Amplitude complète du mouvement
''',
    ),

    // Exercices de dos
    'deadlift': ExerciseVideoData(
      youtubeId: 'op9kVnSso6Q',
      title: 'Soulevé de Terre - Guide Complet',
      description: '''
Le soulevé de terre est l'exercice le plus complet pour le corps entier.

**Points Clés:**
• Dos TOUJOURS droit
• Barre proche des tibias
• Poussez avec les jambes d'abord
• Gardez les épaules au-dessus de la barre
• Verrouillez en haut avec les hanches

**Muscles Travaillés:**
• Lombaires
• Fessiers
• Ischio-jambiers
• Trapèzes
• Avant-bras

**Erreurs Communes:**
❌ Arrondir le dos
❌ Tirer avec les bras
❌ Commencer avec les hanches trop hautes
❌ Regarder en haut (garder le cou neutre)
''',
    ),

    'pull up': ExerciseVideoData(
      youtubeId: '1zMaL4OkW4I',
      title: 'Tractions - Maîtriser la Technique',
      description: '''
Les tractions sont l'exercice roi pour le dos et les biceps.

**Points Clés:**
• Prise largeur épaules ou plus large
• Descente contrôlée
• Montez jusqu'au menton au-dessus de la barre
• Gardez les abdos contractés
• Évitez le balancement

**Variantes:**
• Prise large: focus dorsaux
• Prise serrée: focus biceps
• Prise neutre: équilibrée
''',
    ),

    // Exercices de jambes
    'squat': ExerciseVideoData(
      youtubeId: 'ultWZbUMPL8',
      title: 'Squat - Technique Parfaite',
      description: '''
Le squat est l'exercice fondamental pour les jambes.

**Points Clés:**
• Pieds largeur épaules
• Orteils légèrement vers l'extérieur
• Descendez jusqu'aux cuisses parallèles au sol
• Genoux alignés avec les orteils
• Dos droit, regard devant
• Poussez par les talons

**Muscles Travaillés:**
• Quadriceps (principal)
• Fessiers
• Ischio-jambiers
• Lombaires (stabilisation)

**Erreurs Communes:**
❌ Genoux qui rentrent vers l'intérieur
❌ Talons qui décollent
❌ Dos qui s'arrondit
❌ Descente pas assez profonde
''',
    ),

    'leg press': ExerciseVideoData(
      youtubeId: 'IZxyjW7MPJQ',
      title: 'Presse à Cuisses - Guide Complet',
      description: '''
La presse à cuisses permet de travailler les jambes en sécurité.

**Points Clés:**
• Pieds largeur épaules sur la plateforme
• Descendez jusqu'à 90° de flexion
• Poussez sans verrouiller les genoux
• Gardez le bas du dos plaqué au siège
''',
    ),

    // Exercices d'épaules
    'shoulder press': ExerciseVideoData(
      youtubeId: 'qEwKCR5JCog',
      title: 'Développé Militaire - Technique',
      description: '''
Le développé militaire développe les épaules de manière complète.

**Points Clés:**
• Debout ou assis
• Barre devant ou derrière (devant recommandé)
• Poussez verticalement
• Gardez les abdos contractés
• Ne cambrez pas le dos

**Muscles Travaillés:**
• Deltoïdes (principal)
• Triceps
• Trapèzes supérieurs

**Erreurs Communes:**
❌ Cambrer excessivement le dos
❌ Utiliser l'élan des jambes
❌ Bloquer les coudes en haut
''',
    ),

    'lateral raise': ExerciseVideoData(
      youtubeId: '3VcKaXpzqRo',
      title: 'Élévations Latérales - Deltoïdes',
      description: '''
Les élévations latérales isolent les deltoïdes latéraux.

**Points Clés:**
• Légère flexion des coudes
• Montez jusqu'à hauteur d'épaules
• Contrôlez la descente
• Évitez de balancer
• Pensez à "verser de l'eau"
''',
    ),

    // Exercices de bras
    'bicep curl': ExerciseVideoData(
      youtubeId: 'ykJmrZ5v0Oo',
      title: 'Curl Biceps - Technique Parfaite',
      description: '''
Le curl biceps est l'exercice de base pour les biceps.

**Points Clés:**
• Coudes fixes le long du corps
• Montée contrôlée
• Contraction en haut
• Descente lente
• Pas de balancement

**Variantes:**
• Barre droite
• Barre EZ
• Haltères (alternés ou simultanés)
• Prise marteau
''',
    ),

    'tricep dip': ExerciseVideoData(
      youtubeId: '0326dy_-CzM',
      title: 'Dips Triceps - Guide Complet',
      description: '''
Les dips sont excellents pour les triceps et les pectoraux.

**Points Clés:**
• Corps légèrement penché en avant
• Descendez jusqu'à 90° de flexion
• Poussez en contractant les triceps
• Gardez les coudes près du corps
• Contrôlez la descente

**Focus:**
• Corps droit = triceps
• Corps penché = pectoraux
''',
    ),

    // Exercices abdominaux
    'plank': ExerciseVideoData(
      youtubeId: 'ASdvN_XEl_c',
      title: 'Planche - Gainage Parfait',
      description: '''
La planche est l'exercice de gainage par excellence.

**Points Clés:**
• Corps aligné (tête-épaules-hanches-pieds)
• Abdos et fessiers contractés
• Respirez normalement
• Regardez le sol
• Tenez la position

**Erreurs Communes:**
❌ Hanches trop hautes
❌ Hanches qui tombent
❌ Tête relevée
❌ Retenir sa respiration
''',
    ),

    'crunch': ExerciseVideoData(
      youtubeId: 'Xyd_fa5zoEU',
      title: 'Crunch - Abdominaux',
      description: '''
Le crunch cible les abdominaux supérieurs.

**Points Clés:**
• Mains derrière la tête (sans tirer)
• Montez les épaules du sol
• Contractez les abdos
• Descente contrôlée
• Bas du dos au sol
''',
    ),
  };

  /// Récupère les données vidéo pour un exercice
  static ExerciseVideoData? getVideoForExercise(String exerciseName) {
    final key = exerciseName.toLowerCase().trim();
    return videos[key];
  }

  /// Vérifie si une vidéo existe pour cet exercice
  static bool hasVideo(String exerciseName) {
    return videos.containsKey(exerciseName.toLowerCase().trim());
  }
}

/// Données d'une vidéo d'exercice
class ExerciseVideoData {
  final String youtubeId;
  final String title;
  final String description;

  const ExerciseVideoData({
    required this.youtubeId,
    required this.title,
    required this.description,
  });

  /// URL complète de la vidéo YouTube
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$youtubeId';
}
