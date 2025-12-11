import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity>();
  UserEntity _currentUser = UserEntity.empty;
  final _uuid = const Uuid();

  MockAuthRepository() {
    // Simuler un utilisateur non connecté au départ
    // Pour simuler un utilisateur déjà connecté, decommenter la ligne suivante :
    // _currentUser = const UserEntity(id: '123', email: 'test@fittrack.com', displayName: 'Test User');
    _controller.add(_currentUser);
  }

  @override
  Stream<UserEntity> get user => _controller.stream;

  @override
  UserEntity get currentUser => _currentUser;

  @override
  Future<void> logIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simuler délai réseau
    
    if (password == 'error') {
      throw Exception('Mot de passe incorrect');
    }

    _currentUser = UserEntity(
      id: _uuid.v4(),
      email: email,
      displayName: email.split('@')[0],
      photoUrl: 'https://i.pravatar.cc/150?u=$email',
    );
    
    _controller.add(_currentUser);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserEntity(
      id: _uuid.v4(),
      email: email,
      displayName: email.split('@')[0],
      photoUrl: 'https://i.pravatar.cc/150?u=$email',
    );
    
    _controller.add(_currentUser);
  }

  @override
  Future<void> logOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserEntity.empty;
    _controller.add(_currentUser);
  }
  
  void dispose() => _controller.close();
}
