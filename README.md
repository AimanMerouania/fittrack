# 🏋️‍♂️ FitTrack - Application de Fitness Premium

FitTrack est une application mobile de suivi d'entraînement développée en **Flutter**, conçue pour offrir une expérience utilisateur fluide, motivante et esthétique (Dark Mode / Glassmorphism).

## 🎯 Ce que l'application apporte

### 🎧 Pour l'utilisateur
1.  **Suivi structuré** : Consultation d'exercices par muscle, création de programmes personnalisés (Bras, Dos, Full Body...), et historique détaillé.
2.  **Motivation et discipline** : Visualisation de la progression (Graphiques Néon), Gamification (Barre d'XP "Titan"), et objectifs clairs.
3.  **Accessibilité et simplicité** : Interface "Cyberpunk" responsive et intuitive avec **synchronisation cloud Firebase**.
4.  **Gain de temps** : Lancement de séance en 1 clic, catalogue d'exercices intégré avec images explicatives.

### 📱 Valeur ajoutée fonctionnelle
| Fonction | Apport réel |
| :--- | :--- |
| **Authentification Firebase** | Sécurise les données, synchronisation multi-appareils |
| **Programmes Premium** | Interface ultra-moderne avec statistiques et prévisualisations |
| **Base de données Cloud** | Sauvegarde automatique sur Firebase Firestore |
| **Mode Séance Active** | Chronomètre intégré, validation des séries en temps réel |
| **Statistiques** | Graphiques interactifs (Charts) pour visualiser le volume et l'équilibre |
| **Gamification** | Système d'XP et de niveaux pour rendre le sport addictif |
| **UI Moderne** | Design **Glassmorphism**, animations fluides, Thème Sombre & Néon |
| **Images d'Exercices** | Illustrations professionnelles avec indications anatomiques |

## 🎓 Stack Technique (Pédagogie)

Ce projet démontre la maîtrise des compétences clés du développement mobile moderne :

*   **Framework** : Flutter (Dart)
*   **Architecture** : Clean Architecture (Presentation, Domain, Data)
*   **State Management** : **BLoC / Cubit** (Gestion d'état réactive et propre)
*   **Backend** : **Firebase** (Authentication, Firestore Database)
*   **Persistence Locale** : **Sqflite** (Cache local, mode hors-ligne)
*   **Data Source** : Repository Pattern (Abstrait, permet de switcher Mock/Firebase)
*   **UI/UX** : Material 3, Custom Themes, Animations (flutter_animate), Composants réutilisables (GlassCard)
*   **Graphiques** : Intégration de `fl_chart`
*   **Assets** : Images d'exercices générées par IA

## 🔥 Configuration Firebase

FitTrack utilise Firebase pour l'authentification et la base de données cloud.

### Configuration rapide:

1. **Consultez le guide complet**: Voir [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
2. **Créez un projet Firebase**: https://console.firebase.google.com/
3. **Copiez vos clés** dans `lib/core/config/firebase_config.dart`
4. **Activez Authentication** (Email/Password) dans la console
5. **Créez une base Firestore** avec les règles de sécurité

### Mode Mock (sans Firebase):

Si Firebase n'est pas configuré, l'application fonctionne en **mode Mock** avec des données de démonstration locales.

## 🚀 Comment lancer le projet

1.  **Installation des dépendances** :
    ```bash
    flutter pub get
    ```

2.  **Lancement (Web ou Mobile)** :
    ```bash
    flutter run -d chrome
    ```

3.  **Configuration Firebase** (optionnel mais recommandé):
    - Suivez les instructions dans [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

## 📸 Fonctionnalités Principales

- ✅ **Onboarding animé** avec design premium
- ✅ **Authentification Firebase** (Email/Password + Google Sign-In)
- ✅ **Page d'accueil** avec gamification (XP Bar)
- ✅ **Bibliothèque d'exercices** avec images explicatives
- ✅ **Créateur de programmes** avec interface intuitive
- ✅ **Page Programmes Premium** avec statistiques et prévisualisations
- ✅ **Mode séance active** avec chronomètre
- ✅ **Statistiques et graphiques** de progression
- ✅ **Synchronisation cloud** Firebase Firestore

## 🎨 Design

- **Thème sombre** avec effets glassmorphism
- **Couleurs néon** (Cyan, Purple, Green)
- **Animations fluides** avec flutter_animate
- **Typographie** Google Fonts (Outfit)
- **Images d'exercices** professionnelles

---
*Développé avec passion pour repousser les limites du fitness mobile.*
