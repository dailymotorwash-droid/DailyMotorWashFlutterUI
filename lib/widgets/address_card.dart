
import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';
import '../utils/custom_text_styles.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool selected;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.secondary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.blackFont12Bold),
                  const SizedBox(height: 4),
                  Text(address, style: AppTextStyles.blackFont12Regular),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}