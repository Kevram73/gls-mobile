import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:gls/controllers/loginController.dart';
import 'package:gls/helpers/coloors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Évite les problèmes avec le clavier
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: Coloors.primaryColor,
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Nom"),
            _buildTextField(controller.firstNameController, "Entrez votre nom"),

            _buildLabel("Prénom"),
            _buildTextField(
                controller.lastNameController, "Entrez votre prénom"),

            _buildLabel("Numéro de téléphone"),
            IntlPhoneField(
              controller: controller.phoneController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialCountryCode: 'TG',
              keyboardType: TextInputType.phone,
            ),

            _buildLabel("Email"),
            _buildTextField(controller.emailController, "Entrez votre email",
                TextInputType.emailAddress),

            _buildLabel("Mot de passe"),
            Obx(() => _buildPasswordField(
                controller.passwordController,
                "Entrez votre mot de passe",
                controller.isPasswordHidden,
                controller.togglePasswordVisibility)),

            _buildLabel("Confirmez le mot de passe"),
            Obx(() => _buildPasswordField(
                controller.confirmPasswordController,
                "Confirmez votre mot de passe",
                controller.isConfirmPasswordHidden,
                controller.toggleConfirmPasswordVisibility)),

            const SizedBox(height: 25),

            // 🟢 **Register Button**
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isRegisterFormValid.value &&
                              !controller.isLoading.value
                          ? Coloors.primaryColor
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: controller.isRegisterFormValid.value &&
                            !controller.isLoading.value
                        ? controller.register
                        : null,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white) // 🔥 Affiche un loader
                        : const Text("S'inscrire",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )),

            const SizedBox(height: 15),
            _buildLoginRedirect(),
          ],
        ),
      ),
    );
  }

  /// 📌 **Reusable Label Widget**
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// 📝 **Reusable TextField**
  Widget _buildTextField(TextEditingController controller, String hintText,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: hintText),
      keyboardType: keyboardType,
    );
  }

  /// 🔐 **Reusable Password Field**
  Widget _buildPasswordField(TextEditingController controller, String hintText,
      RxBool isHidden, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isHidden.value,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(isHidden.value ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  /// 🔄 **Redirect to Login**
  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous avez déjà un compte ? "),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Text("Se connecter",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
