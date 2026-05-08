
import 'package:provider/provider.dart';

import '../features/Home/data/controller/home_screen_controller.dart';
import '../features/counter_application_with_provider/data/controller/counter_application_controller.dart';

var providers = [
  ChangeNotifierProvider<HomeScreenController>(
      create: ((context) => HomeScreenController())),
  ChangeNotifierProvider<CounterApplicationController>(
      create: ((context) => CounterApplicationController())),
];