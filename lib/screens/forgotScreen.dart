import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:gls/controllers/loginController.dart';
import 'package:gls/helpers/coloors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Évite les problèmes avec le clavier
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📷 **Image d'illustration**
            SizedBox(
              height: 200,
              child: Image.asset("assets/images/forgot.png", fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),

            // 📝 **Titre**
            const Text(
              "Mot de passe oublié?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // ℹ **Instructions**
            const Text(
              "Ne vous inquiétez pas ! Cela arrive.\nVeuillez saisir le numéro de téléphone associé à votre compte.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // 📱 **Label Numéro**
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Numéro de téléphone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 10),

            // 📞 **Champ de saisie Numéro**
            IntlPhoneField(
              controller: controller.phoneController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Entrez votre numéro"),
              initialCountryCode: 'TG',
            ),
            const SizedBox(height: 20),

            // 🔘 **Bouton Obtenir OTP**
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.phoneController.text.length >= 8
                          ? Coloors.primaryColor
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: controller.phoneController.text.length >= 8 ? controller.forgotPassword : null,
                    child: const Text("Valider", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
