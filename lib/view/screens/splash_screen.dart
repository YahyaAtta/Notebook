import 'package:flutter/material.dart';
import 'package:note_book/model/data_static/assets_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: Image.asset(AssetsImageModel.notebook,
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width),
    ));
  }
}
