import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/loginController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/forgotScreen.dart';
import 'package:gls/screens/registerScreen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: false, // ✅ Évite les problèmes avec le clavier
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Connexion",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
          
              // 📱 **Numéro de téléphone**
              const Text("Numéro de téléphone", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              IntlPhoneField(
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Entrez votre numéro",
                ),
                initialCountryCode: 'TG', 
              ),
          
              const SizedBox(height: 15),
          
              // 🔒 **Mot de passe**
              const Text("Mot de passe", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: "Entrez votre mot de passe",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
          
              // 🔗 **Mot de passe oublié**
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                    child: const Text("Mot de passe oublié ?"),
                  ),
                ],
              ),
          
              // ✅ **Bouton de connexion**
              const SizedBox(height: 10),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isLoginFormValid.value ? Coloors.primaryColor : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: controller.isLoginFormValid.value ? controller.login : null,
                      child: const Text("Se connecter", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  )),
          
              const SizedBox(height: 20),
          
              // 📌 **Lien pour s'inscrire**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous n'avez pas de compte ? "),
                  GestureDetector(
                    onTap: () => Get.to(() => const RegisterScreen()),
                    child: const Text("S’inscrire", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
