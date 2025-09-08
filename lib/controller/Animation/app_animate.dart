import 'package:flutter/cupertino.dart';

class Slide extends PageRouteBuilder {
  // offset
  // ignore: prefer_typing_uninitialized_variables
  final Widget page;
  Slide({required this.page})
      : super(
            pageBuilder: (context, animation, animationtwo) => page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              Offset end = const Offset(0, 0);
              Offset begin = const Offset(1, 0);
              Tween<Offset> tween = Tween(begin: begin, end: end);
              var offsetanimation = animation.drive(tween);
              return SlideTransition(
                position: offsetanimation,
                child: child,
              );
            });
}

class Scale extends PageRouteBuilder {
  // offset
  // ignore: prefer_typing_uninitialized_variables
  final Widget page;
  Scale({required this.page})
      : super(
            pageBuilder: (context, animation, animationtwo) => page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              double begin = 0.0;
              double end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var curvedAnimation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutCirc);
              return ScaleTransition(
                scale: tween.animate(curvedAnimation),
                child: child,
              );
            });
}

class Size extends PageRouteBuilder {
  // offset
  // Slide Scale Rotation tween ,  Curved Animation
  // Size Fade animation value
  // ignore: prefer_typing_uninitialized_variables
  final Widget page;
  Size({required this.page})
      : super(
            pageBuilder: (context, animation, animationtwo) => page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              return Align(
                alignment: Alignment.topCenter,
                child: SizeTransition(sizeFactor: animation, child: child),
              );
            });
}

class CupertinoAnimation extends PageRouteBuilder {
  final Widget page;
  CupertinoAnimation({required this.page})
      : super(
            pageBuilder: (context, animation, animationtwo) => page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              return CupertinoPageTransition(
                  primaryRouteAnimation: animation,
                  secondaryRouteAnimation: animationtwo,
                  linearTransition: false,
                  child: child);
            });
}
