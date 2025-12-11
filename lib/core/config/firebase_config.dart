// INSTRUCTIONS DE CONFIGURATION FIREBASE
// ========================================
//
// Pour configurer Firebase dans votre application FitTrack:
//
// 1. Allez sur https://console.firebase.google.com/
// 2. Créez un nouveau projet ou sélectionnez un projet existant
// 3. Ajoutez une application Web à votre projet
// 4. Copiez la configuration Firebase fournie
// 5. Remplacez les valeurs ci-dessous par vos propres clés
//
// IMPORTANT: Ne partagez jamais vos clés Firebase publiquement!

class FirebaseConfig {
  // 🔥 Configuration Firebase pour FitTrack
  static const String apiKey = "AIzaSyAJkjDxCBhkzekKP1FNTwwaGA9Ukm8-IKU";
  static const String authDomain = "fittrack-f0f39.firebaseapp.com";
  static const String projectId = "fittrack-f0f39";
  static const String storageBucket = "fittrack-f0f39.firebasestorage.app";
  static const String messagingSenderId = "679322951646";
  static const String appId = "1:679322951646:web:ffa40185e57ab3afe5074f";
  static const String measurementId = "G-ZSYD2G7KCE";

  // Realtime Database URL (sera généré automatiquement)
  static const String databaseURL =
      "https://fittrack-f0f39-default-rtdb.europe-west1.firebasedatabase.app";

  // Configuration pour Firebase Web
  static Map<String, String> get webConfig => {
        'apiKey': apiKey,
        'authDomain': authDomain,
        'projectId': projectId,
        'storageBucket': storageBucket,
        'messagingSenderId': messagingSenderId,
        'appId': appId,
        if (measurementId.isNotEmpty) 'measurementId': measurementId,
      };

  // Vérifie si Firebase est configuré
  static bool get isConfigured {
    return apiKey != "VOTRE_API_KEY" && projectId != "VOTRE_PROJECT_ID";
  }
}
