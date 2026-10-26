import 'dart:async';

import 'package:dmw/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/banner_model.dart';

class CurrentOfferWidget extends StatefulWidget{

  const CurrentOfferWidget({ super.key });

  @override
  State<CurrentOfferWidget> createState() => _CurrentOfferWidgetState();

}

class _CurrentOfferWidgetState extends State<CurrentOfferWidget> {

  late BannerProvider read,watch;
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    read = context.read<BannerProvider>();
    // Trigger provider's fetch method directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().fetchBanners();
    });
  }
  void _startAutoScroll(int totalCount) {
    if (totalCount <= 1 || _autoScrollTimer != null) return;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % totalCount;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context){
    final bannerWatch = context.watch<BannerProvider>();
    final List<BannerModel> banners = bannerWatch.banners;
    if (bannerWatch.isLoading) {
      return Container(
        height: 145.0,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    _startAutoScroll(banners.length);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 145.0,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildBannerCard(banners[index]);
            },
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final bool isSelected = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: isSelected ? 16 : 5,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE53935) : const Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );

    //   Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: AppColors.darkBackground,
    //     borderRadius: BorderRadius.circular(12)
    //   ),
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Image.asset('assets/images/logo.png', height: 100, width: 100,),
    //           const SizedBox(width: 12),
    //           const Expanded(
    //             child: CustomRichText(
    //               arrayLength: 2,
    //               callBacksInOrder: const [null, null],
    //               textsInOrder: [
    //                 'Get Complete Car Wash at your Doorstep\n\n',
    //                'Full Exterior Body Wash - Internal Cleaning - Polishing'
    //               ],
    //               textStylesInOrder: [AppTextStyles.whiteFont12Bold, AppTextStyles.whiteFont12Regular]
    //             ),
    //           )
    //         ],
    //       ),
    //       const SizedBox(height: 4),
    //       ElevatedButton(
    //         onPressed: () {
    //
    //         },
    //         style: AppButtonStyles.primaryButtonStyle,
    //         // child: const Text('Book Now', style: AppTextStyles.whiteFont16Bold)
    //         child: const Text('Coming Soon', style: AppTextStyles.whiteFont16Bold)
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _buildBannerCard(BannerModel banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => openBannerLink(banner.redirectLink),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 1080,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF2C2C2C),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white38,
                    size: 32,
                  ),
                ),
              ),
              // if (banner.title != null && banner.title!.isNotEmpty)
              //   Positioned(
              //     left: 0,
              //     right: 0,
              //     bottom: 0,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [
              //             Colors.black.withOpacity(0.75),
              //             Colors.transparent,
              //           ],
              //           begin: Alignment.bottomCenter,
              //           end: Alignment.topCenter,
              //         ),
              //       ),
              //       child: Text(
              //         banner.title!,
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //         style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openBannerLink(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) return;

    final String sanitizedUrl = rawUrl.trim();

    // Validate https protocol
    if (!sanitizedUrl.toLowerCase().startsWith('https://')) {
      debugPrint('Rejected insecure or invalid scheme: $sanitizedUrl');
      return;
    }

    final Uri? uri = Uri.tryParse(sanitizedUrl);
    if (uri == null) {
      debugPrint('Failed to parse URL: $sanitizedUrl');
      return;
    }

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in device's default browser
      );

      if (!launched) {
        debugPrint('Could not launch URL: $sanitizedUrl');
      }
    } catch (e) {
      debugPrint('Error launching banner URL: $e');
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}