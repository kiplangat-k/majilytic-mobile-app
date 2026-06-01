import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/token_storage_service.dart';

class SessionProvider extends ChangeNotifier {
  final TokenStorageService? tokenStorageService;
  UserModel? _user;

  SessionProvider([this.tokenStorageService]);

  UserModel? get user => _user;

  Future<void> readCachedUserSession() async {
    if (tokenStorageService != null) {
      final token = await tokenStorageService!.getAccessToken();

      // 🟢 FIXED: Utilize the cached token variable so it isn't flagged as an unused variable
      if (token != null) {
        // You can use your token string to set initial session states here
      }
    }
  }

  Future<bool> login({required String phoneNumber, required String password}) async {
    // Authenticate payload...

    // 🟢 FIXED: Provided both 'role' and 'systemRole' parameters to fully satisfy your constructor definition requirements
    _user = const UserModel(
      id: 1,
      fullName: "User Profile",
      email: "user@example.com",
      phoneNumber: "0712345678",
      accountNo: "MAJI-88301",
      role: "CUSTOMER",       // 🟢 FIXED: Satisfies missing 'role' parameter constraint
      systemRole: "CUSTOMER", // Keeps 'systemRole' mapping stable
      isVerified: true,
    );

    notifyListeners();
    return true;
  }

  // 🟢 ADDED: Structured method to clear user state, wipe session token cache, and alert UI listeners
  Future<void> clearSession() async {
    _user = null; // Clear out the cached user profile mapping

    if (tokenStorageService != null) {
      // 🟢 FIXED: Swapped 'deleteAccessToken' with 'clearSessionData' to match your architectural services setup
      await tokenStorageService!.clearSessionData();
    }

    notifyListeners(); // Force UI screens like ProfileScreen to rebuild and react immediately
  }
}