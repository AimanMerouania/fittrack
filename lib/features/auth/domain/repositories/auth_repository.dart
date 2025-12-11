import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity> get user;
  
  Future<void> logIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> logOut();
  
  UserEntity get currentUser;
}
