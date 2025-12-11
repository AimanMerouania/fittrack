import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  UserEntity _currentUser = UserEntity.empty;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    // Initialize current user
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      _currentUser = _mapFirebaseUser(firebaseUser);
    });
  }

  @override
  Stream<UserEntity> get user {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  UserEntity get currentUser => _currentUser;

  @override
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = _mapFirebaseUser(userCredential.user);
    } catch (e) {
      throw Exception('Connexion échouée: ${e.toString()}');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = _mapFirebaseUser(userCredential.user);
    } catch (e) {
      throw Exception('Inscription échouée: ${e.toString()}');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
      _currentUser = UserEntity.empty;
    } catch (e) {
      throw Exception('Déconnexion échouée: ${e.toString()}');
    }
  }

  // Helper method to map Firebase User to UserEntity
  UserEntity _mapFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) {
      return UserEntity.empty;
    }

    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
