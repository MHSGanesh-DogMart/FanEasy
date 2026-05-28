import 'package:faneasy/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/mock_cities_data.dart';
import '../providers/cities_provider.dart';
import 'host_city_card.dart';

/// `PageView`-backed carousel of host cities with a row of indicator
/// dots below it.
class HostCityCarousel extends StatefulWidget {
  const HostCityCarousel({super.key});

  @override
  State<HostCityCarousel> createState() => _HostCityCarouselState();
}

class _HostCityCarouselState extends State<HostCityCarousel> {
  late final PageController _controller;
  CitiesProvider? _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CitiesProvider>();
    _controller = PageController(
      initialPage: _provider!.selectedCityIndex,
      viewportFraction: 0.92,
    );
    _provider!.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (_provider != null && _controller.hasClients) {
      final newIndex = _provider!.selectedCityIndex;
      if (_controller.page?.round() != newIndex) {
        _controller.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.scaffoldBackground,
          height: 320.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: kMockHostCities.length,
            onPageChanged: (i) => context.read<CitiesProvider>().selectCity(i),
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: HostCityCard(city: kMockHostCities[i]),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _Dots(count: kMockHostCities.length),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final active = context.select<CitiesProvider, int>(
      (p) => p.selectedCityIndex,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: selected ? 7.r : 6.r,
          height: selected ? 7.r : 6.r,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF262626) : const Color(0xFFE2E2E2),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
