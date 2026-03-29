import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_enums.dart';
import 'package:flutter/material.dart';


// class DropdownUnderlinedField<T> extends StatelessWidget {
//   final String labelText;
//   final List<T> options;
//   final T value;
//   final void Function(T?) onChanged;

//   const DropdownUnderlinedField({
//     super.key,
//     this.labelText = 'Please select an Option',
//     this.options = const [],
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FormField<T>(
//       builder: (FormFieldState<T> state) {
//         return InputDecorator(
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//             labelText: labelText,
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//           ),
//           isEmpty: value == null || value == '',
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<T>(
//               value: value,
//               isDense: true,
//               onChanged: onChanged,
//               items: options.map((T value) {
//                 return DropdownMenuItem<T>(
//                   value: value,
//                   child: Text(value.toString()),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class DropdownUnderlinedField<T> extends StatelessWidget {

  final T? value;
  final String labelText;
  final ColorTheme colorTheme;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const DropdownUnderlinedField({ 
    super.key,
    this.colorTheme = ColorTheme.light,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context){
    return DropdownButtonFormField(
      value: value,
      items: items, 
      onChanged: onChanged,
      style: colorTheme == ColorTheme.light 
      ? const TextStyle(color: AppColors.black) 
      : const TextStyle( color: AppColors.white),
      iconEnabledColor: colorTheme == ColorTheme.light ? AppColors.darkBackground :AppColors.lightBackground,
      dropdownColor: colorTheme == ColorTheme.light ? AppColors.lightBackground : AppColors.secondary,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: colorTheme == ColorTheme.light 
        ? const TextStyle(color: AppColors.darkBackground) 
        : const TextStyle( color: AppColors.lightBackground),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme == ColorTheme.light ? AppColors.darkBackground : AppColors.lightBackground,
            width: 0.5
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorTheme == ColorTheme.light ? AppColors.black : AppColors.white,
            width: 2,
          )
        ),
      ),
    );
  }
}