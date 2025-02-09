import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/introController.dart';
import 'package:gls/helpers/coloors.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    IntroController controller = Get.put(IntroController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Coloors.primaryColor,
        body: Center(
          child: const Text(
            "Galore Loto Services",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Coloors.whiteColor),
          ),
        ),
      ),
    );
  }
}