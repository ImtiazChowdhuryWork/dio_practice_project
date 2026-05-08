import 'package:dio_practice_project/constants/app_list.dart';
import 'package:dio_practice_project/constants/text_font_style.dart';
import 'package:dio_practice_project/gen/colors.gen.dart';
import 'package:dio_practice_project/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data/controller/counter_application_controller.dart';

class CounterApplicationWithProvider extends StatelessWidget {
  const CounterApplicationWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterApplicationController>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(
              'Counter Application With Provider',
              style: TextFontStyle.headline14w400cFFFFFFStylePoppins,
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              value.add();
            },
            label: Icon(Icons.add),
          ),
          body: SingleChildScrollView(
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
                      value.counterList.last.toString(),
                      style: TextFontStyle.headline18w500cfefefeStylePoppins,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(20.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.counterList.length,
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
                        value.counterList[index].toString(),
                        style: TextFontStyle.headline18w500cfefefeStylePoppins,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
