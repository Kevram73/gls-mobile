import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/dashboardController.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final DashboardController controller = Get.find<DashboardController>();
  final RxBool _isObscured = true.obs;
  final RxString newPassword = ''.obs;
  final RxString confirmPassword = ''.obs;

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      controller.changePassword(
        _oldPasswordController.text, 
        _newPasswordController.text, 
        _confirmPasswordController.text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Changer le mot de passe"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField("Ancien mot de passe", _oldPasswordController),
                const SizedBox(height: 15),
                _buildPasswordField("Nouveau mot de passe", _newPasswordController, onChanged: (val) => newPassword.value = val),
                const SizedBox(height: 15),
                _buildPasswordField("Confirmer le nouveau mot de passe", _confirmPasswordController, confirm: true, onChanged: (val) => confirmPassword.value = val),
                const SizedBox(height: 30),
                
                Obx(() {
                  bool passwordsMatch = newPassword.value == confirmPassword.value && newPassword.value.isNotEmpty;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: controller.isLoading.value || !passwordsMatch ? null : _changePassword,
                    child: const Text("Mettre à jour", style: TextStyle(color: Colors.white)),
                  );
                }),

                const SizedBox(height: 10),
                controller.isLoading.value 
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)) 
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {bool confirm = false, Function(String)? onChanged}) {
    return Obx(() {
      return TextFormField(
        controller: controller,
        obscureText: _isObscured.value,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(_isObscured.value ? Icons.visibility_off : Icons.visibility),
            onPressed: () => _isObscured.value = !_isObscured.value,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ce champ est requis";
          }
          if (confirm && value != _newPasswordController.text) {
            return "Les mots de passe ne correspondent pas";
          }
          return null;
        },
      );
    });
  }
}
