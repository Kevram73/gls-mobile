import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gls/controllers/usersController.dart';
import 'package:gls/helpers/coloors.dart';
import 'package:gls/models/user.dart';
import 'package:gls/models/type_user.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final UsersController controller = Get.find<UsersController>();
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _numPhoneController = TextEditingController();
  TypeUser? _selectedTypeUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un utilisateur"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Coloors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: "Prénom",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numPhoneController,
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField<TypeUser>(
                  decoration: InputDecoration(
                    labelText: "Type d'utilisateur",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: controller.typeUsers.map((TypeUser typeUser) {
                    return DropdownMenuItem<TypeUser>(
                      value: typeUser,
                      child: Text(typeUser.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (TypeUser? newValue) {
                    setState(() {
                      _selectedTypeUser = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un type d\'utilisateur';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      email: _emailController.text,
                      numPhone: _numPhoneController.text,
                      typeUserId: _selectedTypeUser!.id,
                    );
                    controller.addUser(newUser.nom!, newUser.prenom!, newUser.email!, newUser.numPhone!, newUser.typeUserId!).then((value){
                      controller.fetchUsers();
                      Get.back();
                    });
                   
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Coloors.primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Ajouter", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
