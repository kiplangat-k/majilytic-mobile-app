import '../entities/user.dart';
import '../repositories/auth_repository_interface.dart';

class RegisterUserUseCase {
  final AuthRepositoryInterface repository;

  RegisterUserUseCase(this.repository);

  Future<User> execute(Map<String, dynamic> userData) async {
    // Apply core business rules or field adjustments here before saving
    return await repository.register(userData);
  }
}