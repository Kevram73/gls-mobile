

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gls/controllers/dashboardController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/screens/components/dashAgentScreen.dart';
import 'package:gls/screens/components/dashboardScreen.dart';
import 'package:gls/screens/components/messagerieScreen.dart';
import 'package:gls/screens/components/notificationScreen.dart';
import 'package:gls/screens/components/settingScreen.dart';
import 'package:gls/screens/newVenteScreen.dart';

class HomeAdminScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final storage = GetStorage();

  HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLogoutConfirmation(context);
        return false;
      },
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (controller.user.value == null) {
          return const Scaffold(body: Center(child: Text("Chargement des données...")));
        }

        // 🔹 Utilisation de `?.` et `??` pour éviter le crash
        final kTabPages = [
          (controller.user.value?.typeUserId ?? 0) == 1 ? DashboardScreen() : DashAgentScreen(),
          const MessagerieScreen(),
          NotificationListScreen(),
          const SettingScreen(),
        ];

        final kBottomNavBarItems = [
          const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.home, size: 20), label: 'Dashboard'),
          const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.message, size: 20), label: "Messagerie"),
          const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.bell, size: 20), label: "Notifications"),
          const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cog, size: 20), label: "Paramètres"),
        ];

        return Scaffold(
          body: kTabPages[controller.currentTabIndex.value], 
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
              Get.to(() => const NewVenteScreen());
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      }),
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
              child: const Text('Annuler', style: TextStyle(color: Coloors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Déconnecter', style: TextStyle(color: Coloors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                storage.erase();
                controller.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
