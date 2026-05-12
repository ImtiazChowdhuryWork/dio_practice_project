import 'package:dio_practice_project/core/styles/text_styles.dart';
import 'package:dio_practice_project/core/utils/ui_helpers.dart';
import 'package:dio_practice_project/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PracticeCardWidget extends StatelessWidget {
  final int serialNumber;
  final String title;
  final void Function()? onTap;

  const PracticeCardWidget({
    super.key,
    required this.serialNumber,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.c2f772f,
          borderRadius: BorderRadius.circular(10.r),
        ),
        width: 1.sw,
        height: 40.h,
        child: Row(
          children: [
            UIHelper.horizontalSpace(10.w),
            Text(
              '$serialNumber.',
              style: TextFontStyle.headline14w500cFFFFFFStylePoppins,
            ),
            UIHelper.horizontalSpace(10.w),
            const VerticalDivider(thickness: 2, color: Colors.blue),
            UIHelper.horizontalSpace(10.w),
            Text(
              title,
              style: TextFontStyle.headline14w500cfefefeStylePoppins,
            ),
          ],
        ),
      ),
    );
  }
}
