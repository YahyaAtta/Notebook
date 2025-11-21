import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/controller/on_boarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatelessWidget {
  Intro({super.key});
  final OnBoardingController onBoardingController = Get.put(
    OnBoardingController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              onBoardingController.onChangedPage(index);
            },
            controller: onBoardingController.pageController,
            itemCount: onBoardingController.pages.length,
            itemBuilder: (context, i) => onBoardingController.pages[i],
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: TextButton(
              onPressed: onBoardingController.skip,
              child: Text(
                "o1".tr,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: SmoothPageIndicator(
                controller: onBoardingController.pageController,
                count: onBoardingController.pages.length,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 16,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.amber,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: TextButton(
              onPressed: onBoardingController.onNext,
              child: GetBuilder<OnBoardingController>(
                builder: (controller) => Text(
                  onBoardingController.currentIndex ==
                          onBoardingController.pages.length - 1
                      ? "o3".tr
                      : "o2".tr,
                  style: TextStyle(
                    color:
                        onBoardingController.currentIndex ==
                            onBoardingController.pages.length - 1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
