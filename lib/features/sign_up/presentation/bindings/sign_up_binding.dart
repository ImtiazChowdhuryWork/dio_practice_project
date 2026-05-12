import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/features/sign_up/domain/usecases/sign_up_usecase.dart';
import 'package:dio_practice_project/features/sign_up/presentation/controllers/sign_up_controller.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(locator<SignUpUseCase>()));
  }
}
