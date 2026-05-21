import '../../core/errors/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<UserModel> registerUser(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.register(data);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> authenticateUser(String phone, String password) async {
    try {
      return await _remoteDataSource.login(phone, password);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<void> confirmVerificationOtp(String phone, String code) async {
    try {
      await _remoteDataSource.verifyOtp(phone, code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}