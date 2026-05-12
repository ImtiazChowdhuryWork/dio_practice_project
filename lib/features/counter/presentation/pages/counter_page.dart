import 'package:dio_practice_project/core/styles/text_styles.dart';
import 'package:dio_practice_project/core/utils/ui_helpers.dart';
import 'package:dio_practice_project/features/counter/presentation/controllers/counter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CounterPage extends GetView<CounterController> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Counter Application With GetX',
          style: TextFontStyle.headline14w400cFFFFFFStylePoppins,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.increment,
        label: const Icon(Icons.add),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.6.sw,
                  height: 80.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    controller.current.toString(),
                    style: TextFontStyle.headline18w500cfefefeStylePoppins,
                  ),
                ),
              ),
              UIHelper.verticalSpace(20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    height: 20.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      controller.values[index].toString(),
                      style: TextFontStyle.headline18w500cfefefeStylePoppins,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
