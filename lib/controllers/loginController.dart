import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/helpers/launchReq.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/screens/homeAdminScreen.dart';
import 'package:gls/screens/loginScreen.dart';
import 'package:gls/screens/verifScreen.dart';

class LoginController extends GetxController {
  final LaunchReq api = LaunchReq();
  final GetStorage storage = GetStorage();
  var isLoading = false.obs;

  // Champs pour login et register
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Champs pour OTP
  final TextEditingController otpController = TextEditingController();
  var otp = ''.obs;
  var resendTimer = 12.obs;
  Timer? _timer;

  // Visibilité des mots de passe
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Validation des champs
  var isLoginFormValid = false.obs;
  var isRegisterFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(validateLoginForm);
    passwordController.addListener(validateLoginForm);
    phoneController.addListener(validateRegisterForm);
    emailController.addListener(validateRegisterForm);
    passwordController.addListener(validateRegisterForm);
    confirmPasswordController.addListener(validateRegisterForm);
    otpController.addListener(() => otp.value = otpController.text);
  }

  /// **Gestion de la visibilité des mots de passe**
  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  /// **Validation du formulaire de connexion**
  void validateLoginForm() {
    isLoginFormValid.value = phoneController.text.isNotEmpty && passwordController.text.length >= 6;
  }

  /// **Validation du formulaire d'inscription**
  void validateRegisterForm() {
    isRegisterFormValid.value = phoneController.text.isNotEmpty &&
        emailController.text.isEmail &&
        passwordController.text.length >= 6 &&
        passwordController.text == confirmPasswordController.text;
  }

  /// **Inscription avec envoi OTP**
  Future<void> register() async {
    if (!isRegisterFormValid.value) {
      Fluttertoast.showToast(msg: "Veuillez remplir tous les champs.", backgroundColor: Colors.red);
      return;
    }
    isLoading.value = true;
    var response = await api.postRequest(Urls.registerUrl, {
      "nom": firstNameController.text,
      "prenom": lastNameController.text,
      "num_phone": phoneController.text,
      "email": emailController.text,
      "type_user_id": 4,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
    });

    isLoading.value = false;

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "Compte créé ! Vérifiez votre OTP.", backgroundColor: Colors.green);
      Get.to(() => VerifScreen()); // Redirige vers la vérification OTP
    }
  }

  /// **Connexion**
  Future<void> login() async {
    if (!isLoginFormValid.value) {
      Fluttertoast.showToast(msg: "Veuillez entrer des informations valides", backgroundColor: Colors.red);
      return;
    }

    var response = await api.postRequest(Urls.loginUrl, {
      "phone": phoneController.text,
      "password": passwordController.text,
    });

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      storage.write("token", response["token"]);
      Fluttertoast.showToast(msg: "Connexion réussie !", backgroundColor: Colors.green);
      Get.offAll(() => HomeAdminScreen());
    }
  }

  /// **Vérification de l’OTP pour activation ou reset password**
  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      Fluttertoast.showToast(msg: "Veuillez entrer un OTP valide", backgroundColor: Colors.red);
      return;
    }

    var response = await api.postRequest(Urls.otpVerifyUrl, {
      "phone": phoneController.text,
      "otp_code": otp.value,
    });

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "OTP validé !", backgroundColor: Colors.green);
      Get.offAll(LoginScreen());// Redirige vers la connexion après activation
    }
  }

  /// **Mot de passe oublié : Envoi OTP**
  Future<void> forgotPassword() async {
    if (phoneController.text.isEmpty || !phoneController.text.isEmail) {
      Fluttertoast.showToast(msg: "Veuillez entrer un email valide", backgroundColor: Colors.red);
      return;
    }

    var response = await api.postRequest(Urls.forgotPasswordUrl, {
      "phone": phoneController.text,
    });

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "Un OTP a été envoyé.", backgroundColor: Colors.green);
      Get.to(() => VerifScreen());
      startResendTimer();
    }
  }

  /// **Réinitialisation du mot de passe**
  Future<void> resetPassword(String token) async {
    if (passwordController.text.length < 6 || passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Les mots de passe ne correspondent pas ou sont trop courts.", backgroundColor: Colors.red);
      return;
    }

    var response = await api.postRequest(Urls.resetPasswordUrl, {
      "phone": phoneController.text,
      "token": token,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
    });

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "Mot de passe réinitialisé !", backgroundColor: Colors.green);
    
      Get.offAll(LoginScreen());
    }
  }

  /// **Démarrer le compte à rebours pour renvoyer l'OTP**
  void startResendTimer() {
    resendTimer.value = 12;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// **Renvoyer un OTP**
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    var response = await api.postRequest(Urls.otpVerifyUrl, {
      "phone": phoneController.text,
    });

    if (response["error"] != null) {
      Fluttertoast.showToast(msg: response["error"], backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "Un nouvel OTP a été envoyé.", backgroundColor: Colors.green);
      startResendTimer();
    }
  }
}
