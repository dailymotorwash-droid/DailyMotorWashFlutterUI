import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/views/booking_screen/calender_screen.dart';
import 'package:car_wash/widgets/custom_rich_text.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({ super.key });

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOKINGS', style: AppTextStyles.primaryFont20Regular,),
        backgroundColor: AppColors.darkBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ...List.generate( 2*5-1, (index) {
                if(index.isOdd) return const SizedBox(height: 16);
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                      (BuildContext context) => const CalenderScreen()
                    )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 0.5)
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('My Car', style: AppTextStyles.blackFont16Regular,),
                              Text('Honda Civic', style: AppTextStyles.blackFont12Regular,),
                              Text('DL1ry57839', style: AppTextStyles.blackFont12Bold,),
                              const Spacer(),
                              Text(
                                index%3==0 ? 'Subscribed' : 'Subscribe Now →', 
                                style:  index%3==0 ? AppTextStyles.primaryFont16Bold : AppTextStyles.secondaryFont16Bold,
                              )
                            ],
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.calendar_month_outlined, size: 120,),
                        ],
                      ),
                    ),
                  ),
                );
              }, 
            ),
            const SizedBox(height: 16),
          ],
        ),
      )
    );
  }
}