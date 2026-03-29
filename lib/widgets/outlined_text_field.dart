
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dmw/utils/custom_colors.dart';

class OutlinedTextField extends StatelessWidget {
  
  final Color fillColor;
  final bool isFilled;
  final bool isFieldEnabled;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String?) onChanged;

  const OutlinedTextField({ 
    super.key,
    this.controller,
    this.errorText,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.isFilled = true,
    this.isFieldEnabled = true,
    this.fillColor = AppColors.lightBackground,
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
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        filled: isFilled,
        fillColor: fillColor,
      ),
    );
  }
}