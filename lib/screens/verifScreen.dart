import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/loginController.dart';
import 'package:gls/screens/loginScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:gls/helpers/coloors.dart';

class VerifScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
            () => const LoginScreen()); // Retourne à l'écran de connexion
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          // 🔥 Ajout de SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // 🔥 Correction ici
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // 🔥 Ajout d'un espace
                const Text(
                  "Vérification OTP",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Image.asset("assets/images/verif.png", height: 150),

                const SizedBox(height: 15),
                const Text(
                  "Entrez le code OTP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Un code OTP à 6 chiffres a été envoyé à",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  controller.emailController.text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Champs OTP
                PinCodeTextField(
                  controller: controller.otpController,
                  length: 6, // OTP de 6 chiffres
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    selectedColor: Coloors.primaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.otp.value = value,
                  appContext: context,
                ),

                const SizedBox(height: 20),

                // Bouton Vérifier
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.otp.value.length == 6
                              ? Coloors.primaryColor
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: controller.otp.value.length == 6
                            ? controller.verifyOtp
                            : null,
                        child: const Text(
                          "Vérifier",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    )),

                const SizedBox(height: 20),

                // Renvoi OTP
                Obx(() => GestureDetector(
                      onTap: controller.resendOtp,
                      child: Text(
                        controller.resendTimer.value > 0
                            ? "Renvoyer (${controller.resendTimer.value}s)"
                            : "Renvoyer OTP",
                        style: TextStyle(
                          fontSize: 14,
                          color: controller.resendTimer.value == 0
                              ? Colors.green
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
