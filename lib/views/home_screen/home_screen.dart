import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/local_storage.dart';
import 'package:dmw/views/home_screen/current_offer_widget.dart';
import 'package:dmw/views/home_screen/doorstep_wash_widget.dart';
import 'package:dmw/views/home_screen/one_time_booking_widget.dart';
import 'package:dmw/views/home_screen/refer_friend_widget.dart';
import 'package:dmw/views/home_screen/subscribed_widget.dart';
import 'package:dmw/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_screen_provider.dart';
import 'service_card_widget.dart';
import 'home_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late UserProvider userProviderRead,userProviderWatch;

  @override
  initState()  {
    // TODO: implement initState
    userProviderRead = context.read<UserProvider>();
    Future.microtask((){
      loadProfile();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProviderWatch =  context.watch<UserProvider>();
    final homeProvider = context.watch<HomeScreenProvider>();
    return Scaffold(
      drawer: const DrawerWidget(),
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        // shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)),
        // bottom: const PreferredSize(
        //   preferredSize: const Size(double.infinity, 16),
        //   child: SizedBox(),
        // ),
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('DMW', style: AppTextStyles.primaryFont20Bold,),
            // const Icon(Icons.pin_drop),
            // const SizedBox(width: 4),
            // const Text('You are at\n {Place}', style: AppTextStyles.whiteFont16Regular),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                // ),
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '₹${userProviderWatch.user?.points ?? 0}',
                    style: AppTextStyles.whiteFont16Bold
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body:  Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text("Hi ${LocalStorage.getFirstName()}", style: AppTextStyles.blackFont20Bold),
                  const SizedBox(height: 12),
                  const HomeTabWidget(),
                ]
                )),
            // const SizedBox(height: 12),
            // const HomeTabWidget(),
            // const CurrentOfferWidget(),
            // const SubscribedWidget(),
            // const SizedBox(height: 20),
            // const DoorstepWashWidget(),
            // const SizedBox(height: 20),
            // const OneTimeBookingWidget(),
            // const SizedBox(height: 20),
            // const ReferFriendWidget(),
            // Swipable views between Subscription (Index 0) and One-Time Service (Index 1)
            Expanded(
              child: PageView(
                controller: homeProvider.pageController,
                onPageChanged: (index) =>
                    context.read<HomeScreenProvider>().onPageChanged(index),
                children: [
                  _buildSubscriptionTab(),
                  _buildOneTimeServiceTab(),
                ],
              ),
      ),
          ],
        )
    );
  }

  Future<void> loadProfile() async{

    UserProfileResponse res  = await RestServiceImp.getProfile();
    if(res.isSuccess){
      userProviderRead.login(res.data);
    }
  }
  // --- Tab 0: Subscription Screen ---
  Widget _buildSubscriptionTab() {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentOfferWidget(),
          SizedBox(height: 16),
          SubscribedWidget(),
          SizedBox(height: 20),
          DoorstepWashWidget(),
          SizedBox(height: 20),
          ReferFriendWidget(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- Tab 1: One-Time Service Screen ---
  Widget _buildOneTimeServiceTab() {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneTimeBookingWidget(),
          SizedBox(height: 16),
          // SubscribedWidget(),
          SizedBox(height: 20),
          ReferFriendWidget(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
