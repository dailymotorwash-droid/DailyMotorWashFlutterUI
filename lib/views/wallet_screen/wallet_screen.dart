import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({ super.key });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final TextEditingController _addAmountController = TextEditingController(text: '500');
  final List<double> _popularLoadAmounts = [500,1000,2000];
  
  int _walletAmount = 0;
  bool _autoDebitEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('WALLET', style: AppTextStyles.primaryFont20Regular,),
        backgroundColor: AppColors.darkBackground,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: AppButtonStyles.secondaryButtonStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹ ${_addAmountController.text}', style: AppTextStyles.whiteFont12Bold,),
              const SizedBox(width: 8),
              const Text('Proceed', style: AppTextStyles.whiteFont16Regular,)
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 4),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column (
                  children: [
                    Text('₹ $_walletAmount', style: AppTextStyles.primaryFont32Bold,),
                    const SizedBox(height: 4,),
                    const Text('Available Amount', style: AppTextStyles.whiteFont12Regular,)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.tertiary
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Load Pocket', style: AppTextStyles.blackFont12Bold,),
                    UnderlinedTextField(
                      hintText: 'Enter Amount Here',
                      helperText: 'Minimum Load Amount is ₹ 250',
                      controller: _addAmountController,
                      onChanged: (value) => null
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_popularLoadAmounts.length, (index) {
                        return ActionChip(
                          onPressed: () {
                            double currentAmount = (_addAmountController.text == "" ? 0.0 : double.parse(_addAmountController.text));
                            double newAmount = currentAmount + _popularLoadAmounts[index];
                            _addAmountController.text = newAmount.toString();
                          },
                          label: Text('+ ${_popularLoadAmounts[index]}', style: AppTextStyles.primaryFont12Bold,),
                          side: const BorderSide(color: AppColors.primary, width: 2),
                        
                          backgroundColor: AppColors.tertiary,
                        );
                      }),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Auto Debit', style: AppTextStyles.blackFont12Bold,),
                        SizedBox(width: 4,),
                        Icon(Icons.info)
                      ],
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _autoDebitEnabled ? AppColors.primary : AppColors.darkBackground,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status\n${_autoDebitEnabled ? 'Enabled' : 'Disabled'}',
                              style: AppTextStyles.whiteFont16Bold,
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _autoDebitEnabled = !_autoDebitEnabled;
                                });
                              }, 
                              child: Text(
                                _autoDebitEnabled ? 'Disable' : 'Enable',
                                style: AppTextStyles.blackFont12Bold,
                              )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {}, 
                  style: AppButtonStyles.tertiary,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Apply Coupon', style: AppTextStyles.blackFont16Regular,),
                      Icon(Icons.forward_sharp, color: AppColors.secondary,),
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}