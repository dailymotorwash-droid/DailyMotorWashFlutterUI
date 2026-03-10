
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_wash/utils/custom_colors.dart';

class UnderlinedTextField extends StatelessWidget {
  
  final ColorTheme colorTheme;
  final bool isFieldEnabled;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String?) onChanged;

  const UnderlinedTextField({ 
    super.key,
    this.controller,
    this.errorText,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.isFieldEnabled = true,
    this.colorTheme = ColorTheme.light,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      onChanged: onChanged,
      enabled: isFieldEnabled,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: colorTheme == ColorTheme.light 
      ? const TextStyle(color: AppColors.darkBackground) 
      : const TextStyle( color: AppColors.lightBackground),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: colorTheme == ColorTheme.light 
        ? const TextStyle(color: AppColors.darkBackground) 
        : const TextStyle( color: AppColors.lightBackground),
        errorText: errorText,
        errorStyle: const TextStyle(color:Colors.redAccent), 
        hintText: hintText,
        hintStyle: colorTheme == ColorTheme.light 
        ? AppTextStyles.blackFont12Regular 
        : AppTextStyles.whiteFont12Regular,
        helperText: helperText,
        helperStyle: colorTheme == ColorTheme.light 
        ? const TextStyle(color: AppColors.darkBackground) 
        : const TextStyle( color: AppColors.lightBackground),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme == ColorTheme.light ? AppColors.darkBackground : AppColors.lightBackground,
            width: 0.5
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme == ColorTheme.light ? AppColors.black : AppColors.white,
            width: 2
          )
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent)
        ),
      ),
    );
  }
}