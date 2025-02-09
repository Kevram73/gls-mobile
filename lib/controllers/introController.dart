import 'package:get/get.dart';
import 'package:gls/screens/loginScreen.dart';

class IntroController extends GetxController{
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const LoginScreen());
    });
  }
}