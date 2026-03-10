import 'package:car_wash/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {

  static const ButtonStyle primaryButtonStyle = ButtonStyle(
    enableFeedback: true,
    elevation: WidgetStatePropertyAll(1),
    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12))
    ))
  );

  static const ButtonStyle secondaryButtonStyle = ButtonStyle(
    enableFeedback: true,
    elevation: WidgetStatePropertyAll(1),
    backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12))
    ))
  );

    static const ButtonStyle tertiary = ButtonStyle(
    enableFeedback: true,
    elevation: WidgetStatePropertyAll(1),
    backgroundColor: WidgetStatePropertyAll(AppColors.tertiary),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12))
    ))
  );

  static const ButtonStyle primaryOutlinedButtonStyle = ButtonStyle(
    enableFeedback: true,
    elevation: WidgetStatePropertyAll(2),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: AppColors.primary, width: 2)
    ))
  );
}

