import 'package:car_wash/models/plan.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/widgets/custom_divider_widget.dart';
import 'package:flutter/material.dart';

class PlanBannerWidget extends StatefulWidget {

  final Plan plan;
  final bool isPlanSelected;

  const PlanBannerWidget({ 
    super.key,
    required this.plan,
    required this.isPlanSelected
  });

  @override
  State<PlanBannerWidget> createState() => _PlanBannerWidgetState();
}

class _PlanBannerWidgetState extends State<PlanBannerWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: widget.isPlanSelected 
        ? Border.all(
          width: 1,
          color: AppColors.primary
        ) : null,
        boxShadow: const [
          BoxShadow (
            color: AppColors.darkBackground,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 1),
          )
        ]
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(enumToString(widget.plan.cycle), style: AppTextStyles.primaryFont16Bold),
                    const Spacer(),
                    Chip(
                      label: Text(widget.isPlanSelected ? 'Selected' : 'Select'),
                      labelStyle: widget.isPlanSelected ? AppTextStyles.whiteFont12Bold : AppTextStyles.secondaryFont12Bold,
                      color: WidgetStatePropertyAll(widget.isPlanSelected ? AppColors.primary : AppColors.white),
                      side: const BorderSide(color: AppColors.primary),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Amount\n₹${widget.plan.rate}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackFont16Regular,
                      ),
                      const CustomDividerWidget(heigth: double.infinity, width: 0.5),
                      Text(
                        'Discount\n₹${widget.plan.discount}', 
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackFont16Regular,
                      ),
                      const CustomDividerWidget(heigth: double.infinity, width: 0.5),
                      Text(
                        'Fixed Price\n₹${widget.plan.rate - widget.plan.discount}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackFont16Bold,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isPlanSelected ? AppColors.primary : Colors.blueGrey.shade100,
            ),
            child: Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 4),
                Text(
                  'Special Discount applied of ₹${widget.plan.discount}',
                  style: widget.isPlanSelected ? AppTextStyles.whiteFont12Bold : AppTextStyles.secondaryFont12Bold,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String enumToString(String cycle){

    switch(cycle){
      case 'MONTHLY':
          return 'Monthly';
      case 'QUARTERLY':
        return 'Quartely';

      case 'YEARLY':
        return 'Yearly';

      default:
        return 'One Time';
    }


  }

  void _handlePlanSelection() {

  }
}