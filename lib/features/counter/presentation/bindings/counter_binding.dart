import 'package:dio_practice_project/features/counter/presentation/controllers/counter_controller.dart';
import 'package:get/get.dart';

class CounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CounterController());
  }
}
