import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: context.read<CitiesProvider>().selectedCityIndex,
      viewportFraction: 0.92,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: kMockHostCities.length,
            onPageChanged: (i) =>
                context.read<CitiesProvider>().selectCity(i),
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
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: selected ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : AppColors.border,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}
