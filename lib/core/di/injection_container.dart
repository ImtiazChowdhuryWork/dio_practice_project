import 'package:dio/dio.dart';
import 'package:dio_practice_project/core/network/dio_client.dart';
import 'package:dio_practice_project/features/sign_in/data/datasources/auth_remote_datasource.dart';
import 'package:dio_practice_project/features/sign_in/data/repositories/auth_repository_impl.dart';
import 'package:dio_practice_project/features/sign_in/domain/repositories/auth_repository.dart';
import 'package:dio_practice_project/features/sign_in/domain/usecases/sign_in_usecase.dart';
import 'package:dio_practice_project/features/sign_up/data/datasources/sign_up_remote_datasource.dart';
import 'package:dio_practice_project/features/sign_up/data/repositories/sign_up_repository_impl.dart';
import 'package:dio_practice_project/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:dio_practice_project/features/sign_up/domain/usecases/sign_up_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

final locator = GetIt.instance;

GetStorage get appData => locator.get<GetStorage>();

Future<void> diSetup() async {
  await _diSetupSync();
  await _diSetupAsync();
}

Future<void> _diSetupSync() async {
  // Storage
  if (!locator.isRegistered<GetStorage>()) {
    await GetStorage.init();
    locator.registerSingleton<GetStorage>(GetStorage());
  }

  // Network
  locator.registerSingleton<Dio>(DioClient.instance);

  // --- Sign In ---
  locator.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(locator<Dio>()),
  );
  locator.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(locator<AuthRemoteDataSource>()),
  );
  locator.registerSingleton<SignInUseCase>(
    SignInUseCase(locator<AuthRepository>()),
  );

  // --- Sign Up ---
  locator.registerSingleton<SignUpRemoteDataSource>(
    SignUpRemoteDataSourceImpl(locator<Dio>()),
  );
  locator.registerSingleton<SignUpRepository>(
    SignUpRepositoryImpl(locator<SignUpRemoteDataSource>()),
  );
  locator.registerSingleton<SignUpUseCase>(
    SignUpUseCase(locator<SignUpRepository>()),
  );
}

Future<void> _diSetupAsync() async {}
