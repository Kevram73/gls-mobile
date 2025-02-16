

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/components/dashboardScreen.dart';
import 'package:gls/screens/components/messagerieScreen.dart';
import 'package:gls/screens/components/notificationScreen.dart';
import 'package:gls/screens/components/settingScreen.dart';
import 'package:gls/screens/newVenteScreen.dart';

class HomeAdminScreen extends StatelessWidget {

  // Instanciation du controller
  final DashboardController controller = Get.put(DashboardController());
  final storage = GetStorage();

  HomeAdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final kTabPages = [
      DashboardScreen(),
      const MessagerieScreen(),
      const NotificationAdminScreen(),
      const SettingScreen(),
    ];
    
    final kBottomNavBarItems = [
      const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.home, size: 20), label: 'Dashboard'),
      const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.message, size: 20), label: "Messagerie"),
      const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.bell, size: 20), label: "Notifications"),
      const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cog, size: 20), label: "Paramètres"),
    ];

    assert(kTabPages.length == kBottomNavBarItems.length);

    return WillPopScope(
      onWillPop: () async {
        // Appeler la fonction de confirmation de déconnexion
        showLogoutConfirmation(context);
        return false; // Retourne false pour empêcher la fermeture immédiate de la page
      },
      child: Scaffold(
        body: Obx(() => kTabPages[controller.currentTabIndex.value]),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          items: kBottomNavBarItems,
          selectedItemColor: Coloors.blackColor,
          unselectedItemColor: Coloors.whiteColor,
          backgroundColor: Coloors.primaryColor,
          currentIndex: controller.currentTabIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: controller.changeTabIndex,
        )),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Coloors.primaryColor,
        onPressed: () {
          Get.to(const NewVenteScreen());
        }, // Action à définir
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              
              child: const Text('Annuler', style: TextStyle(color: Coloors.primaryColor),),
              onPressed: () {
                Navigator.of(context).pop(); 
                },
            ),
            TextButton(
              child: const Text('Déconnecter', style: TextStyle(color: Coloors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop(); 
                storage.erase();
                Get.offAllNamed("/login");
              },
            ),
          ],
        );
      },
    );
  }
}
