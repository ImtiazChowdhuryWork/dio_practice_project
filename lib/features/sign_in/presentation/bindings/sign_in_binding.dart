import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/features/sign_in/domain/usecases/sign_in_usecase.dart';
import 'package:dio_practice_project/features/sign_in/presentation/controllers/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController(locator<SignInUseCase>()));
  }
}
