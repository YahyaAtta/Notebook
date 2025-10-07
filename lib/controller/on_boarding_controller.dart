import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_book/model/data_static/assets_model.dart';
import 'package:note_book/services/service.dart';
import '../view/widgets/intro.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController();
  int currentIndex = 0;
  bool isLastPage = false;
  final List<Widget> pages = [
    IntroComponent(
        title: 'onboardingtitle1'.tr,
        desc: 'onboardingsubtitle1'.tr,
        imagePath: AssetsImageModel.notebook),
    IntroComponent(
        title: 'onboardingtitle2'.tr,
        desc: 'onboardingsubtitle2'.tr,
        imagePath: AssetsImageModel.notebook),
    IntroComponent(
        title: 'onboardingtitle3'.tr,
        desc: "onboardingsubtitle3".tr,
        imagePath: AssetsImageModel.notebook),
  ];
  void skip() {
    pageController.animateToPage(pages.length - 1,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onChangedPage(int index) {
    currentIndex = index;
    if (currentIndex == pages.length - 1) {
      isLastPage = true;
    }
    update();
  }

  void onNext() {
    if (currentIndex < pages.length - 1) {
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      update();
    } else {
      onFinish();
    }
  }

  void onFinish() async {
    await sharedPreferences!.setBool("isFirstTime", false);
    Get.offNamed('/home');
  }

  AudioPlayer audioPlayer = AudioPlayer();
  void playSound() async {
    await audioPlayer.play(AssetSource("start-computeraif-14572.mp3"));
  }

  @override
  void onInit() {
    playSound();
    super.onInit();
  }
}
