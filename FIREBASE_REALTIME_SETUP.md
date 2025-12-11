# 🔥 Configuration Firebase Realtime Database

## ✅ Avantage: Gratuit sans Facturation!

Firebase Realtime Database ne nécessite **PAS** de carte bancaire pour le mode test, contrairement à Firestore.

---

## 🚀 Étapes de Configuration

### 1. Créer la Realtime Database

1. Allez sur la console Firebase: https://console.firebase.google.com/project/fittrack-f0f39/database
2. Cliquez sur **"Créer une base de données"** dans la section **Realtime Database**
3. Choisissez l'emplacement: **"europe-west1"** (ou le plus proche)
4. Choisissez le mode de sécurité: **"Démarrer en mode test"**
5. Cliquez sur **"Activer"**

### 2. Configurer les Règles de Sécurité

Une fois la base créée, allez dans l'onglet **"Règles"** et remplacez par:

#### Pour le Développement (Mode Test):
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

#### Pour la Production (Recommandé):
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "workouts": {
      "$workoutId": {
        ".read": "data.child('userId').val() === auth.uid",
        ".write": "data.child('userId').val() === auth.uid || !data.exists()"
      }
    },
    "exercises": {
      ".read": "auth != null",
      ".write": false
    }
  }
}
```

Cliquez sur **"Publier"** pour sauvegarder.

### 3. Activer l'Authentification

1. Allez dans **"Authentication"**: https://console.firebase.google.com/project/fittrack-f0f39/authentication
2. Cliquez sur **"Commencer"**
3. Dans l'onglet **"Sign-in method"**:
   - Activez **"Email/Password"**
   - Cliquez **"Enregistrer"**

---

## 📊 Structure de la Base de Données

```
fittrack-f0f39/
├── users/
│   └── {userId}/
│       ├── displayName: "John Doe"
│       ├── email: "john@example.com"
│       ├── createdAt: 1234567890
│       └── stats/
│           ├── totalWorkouts: 10
│           └── totalExercises: 50
│
├── workouts/
│   └── {workoutId}/
│       ├── userId: "abc123"
│       ├── name: "Programme Pectoraux"
│       ├── exercises: [...]
│       ├── createdAt: 1234567890
│       └── updatedAt: 1234567890
│
└── exercises/
    └── {exerciseId}/
        ├── name: "Bench Press"
        ├── bodyPart: "chest"
        ├── target: "pectorals"
        ├── equipment: "barbell"
        ├── instructions: [...]
        └── level: "intermediate"
```

---

## ✅ Vérification

Une fois configuré, relancez l'application:

```bash
flutter run -d chrome
```

Vous devriez voir dans la console:
```
✅ Firebase initialisé avec succès!
```

---

## 🆚 Realtime Database vs Firestore

| Caractéristique | Realtime Database | Firestore |
|----------------|-------------------|-----------|
| **Facturation** | ✅ Gratuit en mode test | ❌ Nécessite une carte |
| **Structure** | JSON simple | Documents/Collections |
| **Requêtes** | Limitées | Avancées |
| **Temps réel** | ✅ Excellent | ✅ Bon |
| **Hors ligne** | ✅ Bon | ✅ Excellent |

Pour FitTrack, Realtime Database est **parfait** et **gratuit**! 🎉

---

## 🔒 Sécurité

⚠️ **Important**: 
- En mode test, les données sont accessibles pendant 30 jours
- Passez en mode production avec des règles strictes avant de déployer
- Ne partagez jamais vos clés Firebase publiquement

---

## 🆘 Dépannage

### La base de données ne se crée pas
- Vérifiez que vous êtes sur le bon projet Firebase
- Essayez de rafraîchir la page de la console

### Erreur "Permission denied"
- Vérifiez les règles de sécurité
- Assurez-vous que l'utilisateur est authentifié

### Les données ne se sauvegardent pas
- Vérifiez la console du navigateur pour les erreurs
- Vérifiez que Firebase est bien initialisé

---

## 📚 Ressources

- [Documentation Realtime Database](https://firebase.google.com/docs/database)
- [Règles de Sécurité](https://firebase.google.com/docs/database/security)
- [Structurer les Données](https://firebase.google.com/docs/database/web/structure-data)

---

**C'est tout!** Votre application FitTrack est maintenant prête à utiliser Firebase Realtime Database **gratuitement**! 🚀
