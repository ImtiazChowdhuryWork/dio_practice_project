import 'package:dio_practice_project/features/home/domain/entities/practice_card_entity.dart';
import 'package:dio_practice_project/routes/routes.dart';

class AppList {
  AppList._();

  static final List<PracticeCardEntity> learningList = [
    const PracticeCardEntity(
      serialNumber: 1,
      title: 'Counter Application With GetX',
      routingConstant: Routes.counter,
    ),
    const PracticeCardEntity(
      serialNumber: 2,
      title: 'Sign Up — Dio + Clean Architecture',
      routingConstant: Routes.signUp,
    ),
  ];
}
