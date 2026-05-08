import 'package:dio_practice_project/routes/routes.dart';

import '../features/Home/data/model/practice_card_model.dart';

class AppList {
  AppList._();

  static final List<PracticeCardModel>learningList = <PracticeCardModel>[
    PracticeCardModel(
      serialNumber: 1,
      title: 'Counter Application With Provider',
      routingConstant: Routes.counterApplicationWithProvider,
      ),
  ];
}