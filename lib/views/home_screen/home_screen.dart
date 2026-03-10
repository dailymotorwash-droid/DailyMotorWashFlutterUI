import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/local_storage.dart';
import 'package:car_wash/views/home_screen/current_offer_widget.dart';
import 'package:car_wash/views/home_screen/doorstep_wash_widget.dart';
import 'package:car_wash/views/home_screen/refer_friend_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late UserProvider userProvider;

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        // shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)),
        // bottom: const PreferredSize(
        //   preferredSize: const Size(double.infinity, 16),
        //   child: SizedBox(),
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('CAR WASH', style: AppTextStyles.primaryFont20Bold,),
            // const Icon(Icons.pin_drop),
            // const SizedBox(width: 4),
            // const Text('You are at\n {Place}', style: AppTextStyles.whiteFont16Regular),
            const Spacer(),
            IconButton(
              color: AppColors.white,
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView (
        padding: const EdgeInsets.all(16),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi ${LocalStorage.getFirstName()}", style: AppTextStyles.blackFont20Bold),
            const SizedBox(height: 12),
            const CurrentOfferWidget(),
            const SizedBox(height: 20),
            const DoorstepWashWidget(),
            const SizedBox(height: 20),
            const ReferFriendWidget(),
          ],
        )
      ),
    );
  }
}
