import 'dart:async';
import 'package:flutter/material.dart';

class DealBannerCarousel extends StatefulWidget {
  const DealBannerCarousel({super.key});

  @override
  State<DealBannerCarousel> createState() => _DealBannerCarouselState();
}

class _DealBannerCarouselState extends State<DealBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'THE BIG SHOPPING DAYS',
      'subtitle': 'Up to 70% OFF on Top Electronics & Fashion',
      'tag': 'SPECIAL DEAL',
      'colors': [Color(0xFF2874F0), Color(0xFF0D47A1)],
      'icon': Icons.bolt,
    },
    {
      'title': 'DEALS OF THE DAY',
      'subtitle': 'Exclusive discounts & Free Delivery for all orders',
      'tag': 'LIMITED TIME',
      'colors': [Color(0xFFCC0C39), Color(0xFF880E4F)],
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'MEGA FASHION WEEK',
      'subtitle': 'Men & Women Premium Collections under ₹799',
      'tag': 'TRENDING NOW',
      'colors': [Color(0xFF6200EA), Color(0xFF311B92)],
      'icon': Icons.checkroom,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final b = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: b['colors'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              b['tag'] as String,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            b['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      b['icon'] as IconData,
                      size: 54,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (idx) {
            return Container(
              width: _currentPage == idx ? 16 : 6,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: _currentPage == idx ? const Color(0xFF232F3E) : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
