import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmw/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/banner_model.dart';

class CurrentOfferWidget extends StatefulWidget {
  final double bannerHeight;

  const CurrentOfferWidget({super.key, this.bannerHeight = 180.0});

  @override
  State<CurrentOfferWidget> createState() => _CurrentOfferWidgetState();
}

class _CurrentOfferWidgetState extends State<CurrentOfferWidget> {
  late BannerProvider read, watch;
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    final bannerWatch = context.watch<BannerProvider>();
    final List<BannerModel> banners = bannerWatch.banners;

    // Only show loader if we have NO cached/existing banners yet
    if (bannerWatch.isLoading && banners.isEmpty) {
      return Container(
        height: widget.bannerHeight,
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
          height: widget.bannerHeight,
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
                  color: isSelected
                      ? const Color(0xFFE53935)
                      : const Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
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
              CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF1E1E1E),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF2C2C2C),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white38,
                    size: 32,
                  ),
                ),
              ),
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
