# 🔥 Configuration Firebase pour FitTrack

Ce guide vous explique comment configurer Firebase pour votre application FitTrack.

## 📋 Prérequis

- Un compte Google
- Accès à la [Console Firebase](https://console.firebase.google.com/)

## 🚀 Étapes de Configuration

### 1. Créer un Projet Firebase

1. Allez sur https://console.firebase.google.com/
2. Cliquez sur **"Ajouter un projet"**
3. Nommez votre projet (ex: "FitTrack")
4. Suivez les étapes de création

### 2. Ajouter une Application Web

1. Dans votre projet Firebase, cliquez sur l'icône **Web** (`</>`)
2. Donnez un nom à votre app (ex: "FitTrack Web")
3. Cochez **"Configurer aussi Firebase Hosting"** (optionnel)
4. Cliquez sur **"Enregistrer l'application"**

### 3. Copier la Configuration

Firebase vous donnera un code de configuration qui ressemble à ceci:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "fittrack-xxxxx.firebaseapp.com",
  projectId: "fittrack-xxxxx",
  storageBucket: "fittrack-xxxxx.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890",
  measurementId: "G-XXXXXXXXXX"
};
```

### 4. Configurer l'Application

1. Ouvrez le fichier `lib/core/config/firebase_config.dart`
2. Remplacez les valeurs par défaut par vos propres clés:

```dart
class FirebaseConfig {
  static const String apiKey = "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  static const String authDomain = "fittrack-xxxxx.firebaseapp.com";
  static const String projectId = "fittrack-xxxxx";
  static const String storageBucket = "fittrack-xxxxx.appspot.com";
  static const String messagingSenderId = "123456789012";
  static const String appId = "1:123456789012:web:abcdef1234567890";
  static const String measurementId = "G-XXXXXXXXXX";
}
```

### 5. Activer l'Authentification

1. Dans la console Firebase, allez dans **"Authentication"**
2. Cliquez sur **"Commencer"**
3. Dans l'onglet **"Sign-in method"**, activez:
   - ✅ **E-mail/Mot de passe**
   - ✅ **Google** (optionnel)

### 6. Créer la Base de Données Firestore

1. Dans la console Firebase, allez dans **"Firestore Database"**
2. Cliquez sur **"Créer une base de données"**
3. Choisissez le mode:
   - **Mode test** (pour le développement) - données accessibles pendant 30 jours
   - **Mode production** (pour la production) - nécessite des règles de sécurité

4. Choisissez un emplacement (ex: `europe-west1` pour l'Europe)

### 7. Configurer les Règles de Sécurité Firestore

Pour le développement, utilisez ces règles (dans l'onglet "Règles" de Firestore):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permettre la lecture/écriture uniquement aux utilisateurs authentifiés
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Pour la production, créez des règles plus strictes:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Les utilisateurs peuvent lire/écrire uniquement leurs propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null && 
                           resource.data.userId == request.auth.uid;
    }
    
    match /exercises/{exerciseId} {
      allow read: if request.auth != null;
      allow write: if false; // Seuls les admins peuvent modifier
    }
  }
}
```

## 🧪 Tester la Configuration

1. Lancez l'application: `flutter run -d chrome`
2. Essayez de créer un compte
3. Vérifiez dans la console Firebase > Authentication que l'utilisateur apparaît

## 📊 Structure de la Base de Données

FitTrack utilise les collections suivantes dans Firestore:

```
fittrack/
├── users/
│   └── {userId}/
│       ├── displayName: string
│       ├── email: string
│       ├── createdAt: timestamp
│       └── stats/
│           ├── totalWorkouts: number
│           └── totalExercises: number
│
├── workouts/
│   └── {workoutId}/
│       ├── userId: string
│       ├── name: string
│       ├── exercises: array
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
└── exercises/
    └── {exerciseId}/
        ├── name: string
        ├── bodyPart: string
        ├── target: string
        ├── equipment: string
        ├── instructions: array
        └── level: string
```

## 🔒 Sécurité

⚠️ **IMPORTANT**: Ne partagez jamais vos clés Firebase publiquement!

- Ajoutez `firebase_config.dart` à votre `.gitignore` si vous utilisez Git
- Pour la production, utilisez des variables d'environnement
- Configurez des règles de sécurité strictes dans Firestore

## 🆘 Dépannage

### Erreur: "Firebase not initialized"
- Vérifiez que vous avez bien copié toutes les clés
- Assurez-vous que `FirebaseConfig.isConfigured` retourne `true`

### Erreur d'authentification
- Vérifiez que l'authentification Email/Password est activée dans Firebase
- Vérifiez les règles de sécurité Firestore

### Les données ne se sauvegardent pas
- Vérifiez les règles de sécurité Firestore
- Vérifiez que l'utilisateur est bien authentifié

## 📚 Ressources

- [Documentation Firebase](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

---

**Besoin d'aide?** Consultez la documentation officielle ou créez une issue sur GitHub.
