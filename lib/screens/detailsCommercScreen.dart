import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/helpers/urls.dart';
import 'package:gls/models/user.dart';
import 'package:gls/models/vente.dart';
import 'package:gls/helpers/launchReq.dart';

class CommercialDetailScreen extends StatefulWidget {
  final User user;
  const CommercialDetailScreen({super.key, required this.user});

  @override
  _CommercialDetailScreenState createState() => _CommercialDetailScreenState();
}

class _CommercialDetailScreenState extends State<CommercialDetailScreen> {
  final UsersController controller = Get.find<UsersController>();
  final LaunchReq apiClient = LaunchReq();
  final RxList<Vente> ventes = <Vente>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchUserVentes(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${user.nom} ${user.prenom}"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text("Nom"),
              subtitle: Text(user.nom ?? ""),
            ),
            ListTile(
              title: const Text("Prénom"),
              subtitle: Text(user.prenom ?? ""),
            ),
            ListTile(
              title: const Text("Email"),
              subtitle: Text(user.email ?? ""),
            ),
            ListTile(
              title: const Text("Numéro de téléphone"),
              subtitle: Text(user.numPhone ?? ""),
            ),
            const Divider(),
            const Text("Ventes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...controller.ventes.map((vente) => ListTile(
              title: Text("Vente ID: ${vente.id}"),
              subtitle: Text("Montant: ${vente.montant}"),
            )).toList(),
          ],
        );
      }),
    );
  }
}
