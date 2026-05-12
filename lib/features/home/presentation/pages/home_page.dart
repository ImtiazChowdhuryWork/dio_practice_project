import 'package:dio_practice_project/core/utils/ui_helpers.dart';
import 'package:dio_practice_project/features/home/presentation/controllers/home_controller.dart';
import 'package:dio_practice_project/features/home/presentation/widgets/practice_card_widget.dart';
import 'package:dio_practice_project/shared/constants/app_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppList.learningList.length,
              itemBuilder: (context, index) {
                final data = AppList.learningList[index];
                return PracticeCardWidget(
                  onTap: () => Get.toNamed(data.routingConstant),
                  serialNumber: data.serialNumber,
                  title: data.title,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
