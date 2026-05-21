import '../repositories/auth_repository_interface.dart';

class LoginUserUseCase {
  final AuthRepositoryInterface repository;

  LoginUserUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String phoneNumber, String password) async {
    if (phoneNumber.isEmpty || password.isEmpty) {
      throw Exception('Credentials cannot be submitted empty.');
    }
    return await repository.login(phoneNumber, password);
  }
}