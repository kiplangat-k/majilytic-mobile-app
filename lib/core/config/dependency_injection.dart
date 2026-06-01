// lib/core/config/dependency_injection.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// --- Core App & Network Imports ---
import 'app_config.dart';
import 'env_config.dart';
import '../network/dio_provider.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';

// --- Service Layer Imports ---
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../../features/services/token_storage_service.dart';
import '../../features/services/auth_api_service.dart'; // ✅ FIXED: Added missing import for AuthApiService

// --- Authentication & Session Providers ---
import '../../features/providers/auth_provider.dart';
import '../../features/providers/session_provider.dart';

// --- Feature Module Imports ---
import '../../features/postpaid/billing/billing_service.dart';
import '../../features/postpaid/billing/billing_provider.dart';
import '../../features/postpaid/telemetry/telemetry_service.dart';
import '../../features/postpaid/telemetry/telemetry_provider.dart';
import '../../features/prepaid/wallet/wallet_service.dart';
import '../../features/prepaid/wallet/wallet_provider.dart';
import '../../features/prepaid/valve/valve_service.dart';
import '../../features/prepaid/valve/valve_provider.dart';
import '../../features/dashboard/dashboard_service.dart';
import '../../features/dashboard/dashboard_provider.dart';

final GetIt locator = GetIt.instance;

class DependencyInjection {
  static Future<void> initializeDependencies() async {

    // ==========================================
    // 1. SYSTEM ENVIRONMENT & UTILITY CONFIGS
    // ==========================================
    final EnvConfig environment = EnvConfig.development();
    final AppConfig appConfig = AppConfig(env: environment);
    locator.registerSingleton<AppConfig>(appConfig);

    final storageInstance = await StorageService.init();
    locator.registerSingleton<StorageService>(storageInstance);

    final tokenStorage = TokenStorageService(const FlutterSecureStorage());
    locator.registerSingleton<TokenStorageService>(tokenStorage);


    // ==========================================
    // 2. CORE NETWORK INFRASTRUCTURE PRIMITIVES
    // ==========================================
    final authInterceptor = AuthInterceptor();
    final dioProvider = DioProvider(authInterceptor);
    final Dio dioEngine = dioProvider.createDioInstance();

    locator.registerSingleton<Dio>(dioEngine);
    locator.registerSingleton<ApiClient>(ApiClient(locator<Dio>()));


    // ==========================================
    // 3. CORE & FEATURE DATA LAYER SERVICES
    // ==========================================
    locator.registerLazySingleton<AuthService>(() => AuthService(locator<ApiClient>(), locator<StorageService>()));

    // ✅ FIXED: Registered AuthApiService so it can be safely injected down below
    locator.registerLazySingleton<AuthApiService>(() => AuthApiService());

    locator.registerLazySingleton<DashboardService>(() => DashboardService(locator<ApiClient>()));
    locator.registerLazySingleton<BillingService>(() => BillingService(locator<ApiClient>()));
    locator.registerLazySingleton<TelemetryService>(() => TelemetryService(locator<ApiClient>()));
    locator.registerLazySingleton<WalletService>(() => WalletService(locator<ApiClient>()));
    locator.registerLazySingleton<ValveService>(() => ValveService(locator<ApiClient>()));


    // ==========================================
    // 4. PRESENTATION LAYER STATE PROVIDERS
    // ==========================================

    // ✅ FIXED: Provided 2 required dependencies (AuthApiService & TokenStorageService) to AuthProvider
    locator.registerFactory<AuthProvider>(() => AuthProvider(
      locator<AuthApiService>(),
      locator<TokenStorageService>(),
    ));

    // ✅ FIXED: Changed StorageService to TokenStorageService to match SessionProvider's signature parameter
    locator.registerFactory<SessionProvider>(() => SessionProvider(locator<TokenStorageService>()));

    // Feature Providers
    locator.registerFactory<DashboardProvider>(() => DashboardProvider(locator<DashboardService>()));
    locator.registerFactory<BillingProvider>(() => BillingProvider(locator<BillingService>()));
    locator.registerFactory<TelemetryProvider>(() => TelemetryProvider(locator<TelemetryService>()));
    locator.registerFactory<WalletProvider>(() => WalletProvider(locator<WalletService>()));

    locator.registerFactory<ValveProvider>(() => ValveProvider());
  }
}