import 'package:dio_practice_project/features/counter/domain/entities/counter_entity.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  final _counter = CounterEntity(values: const [0]).obs;

  List<int> get values => _counter.value.values;
  int get current => _counter.value.current;

  void increment() {
    _counter.value = _counter.value.increment();
  }
}
