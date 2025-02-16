import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/screens/homeAdminScreen.dart';
import 'package:gls/screens/loginScreen.dart';

class IntroController extends GetxController{

  var storage = GetStorage();
  

  @override
  void onInit() {
    super.onInit();
    final token = storage.read("token");

    Future.delayed(const Duration(seconds: 3), () {
      if(token != null && token.isNotEmpty) {
        Get.offAll(() => HomeAdminScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }
}