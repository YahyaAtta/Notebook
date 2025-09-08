import 'package:flutter/material.dart';
import 'package:note_book/main.dart';
import 'package:note_book/view/Home/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool isLastPage = false;
  final List<Widget> _pages = [
    IntroComponent(
        title: 'Welcome To Notebook',
        desc: 'Discover The New Features!',
        imagePath: notebookLogo),
    IntroComponent(
        title: 'Explore',
        desc: 'Explore Amazing Features!',
        imagePath: notebookLogo),
    IntroComponent(
        title: 'Get Started',
        desc: "Let's Get Started",
        imagePath: notebookLogo),
  ];
  void _skip() {
    _pageController.animateToPage(_pages.length - 1,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      setState(() {});
    } else {
      _onFinish();
    }
  }

  void _onFinish() {
    sharedPreferences!.setBool("FirstTime", false);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: isLastPage
          ? Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      minimumSize: const Size.fromHeight(80)),
                  onPressed: _onFinish,
                  child: Text("Get Started")),
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Stack(
        children: [
          PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  if (_currentIndex == _pages.length - 1) {
                    isLastPage = true;
                  }
                });
              },
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, i) => _pages[i]),
          Positioned(
              bottom: 40,
              left: 20,
              child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ))),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
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
          _currentIndex == _pages.length - 1
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 40,
                  right: 20,
                  child: TextButton(
                      onPressed: _onNext,
                      child: Text(
                        _currentIndex == _pages.length - 1 ? "Finish" : "Next",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ))),
        ],
      ),
    );
  }
}

class IntroComponent extends StatelessWidget {
  final String title;
  final String desc;
  final String imagePath;
  const IntroComponent(
      {super.key,
      required this.title,
      required this.desc,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 30,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.asset(
              imagePath,
              height: 260,
            )),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}
