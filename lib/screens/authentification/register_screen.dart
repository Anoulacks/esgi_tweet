import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/authentification/login_screen.dart';
import 'package:esgi_tweet/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/Register';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerForm = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _checkPasswordController = TextEditingController();
  final emailValidator = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(labelText: 'Pseudo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    if (!emailValidator.hasMatch(value)) {
                      return 'Format d\'email invalide';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe est trop court';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _checkPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirmer Mot de passe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    if (value != _passwordController.text) {
                      return 'Le Mot de passe n\'est pas identique';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthDateController,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Date de Naissance'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      _birthDateController.text = formattedDate;
                    }
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Numéro de téléphone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    if (value.length != 10) {
                      return 'Le numéro de téléphone doit avoir 10 chiffres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champs Obligatoire';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _isLoading
                    ? null
                    : () async {
                    if (_registerForm.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      bool checkRegister = await RepositoryProvider.of<UsersRepository>(context)
                          .addUser(
                              _firstnameController.text,
                              _lastnameController.text,
                              _pseudoController.text,
                              _birthDateController.text,
                              _phoneNumberController.text,
                              _addressController.text,
                              _emailController.text,
                              _passwordController.text,
                              context);

                      setState(() {
                        _isLoading = false;
                      });

                      if (checkRegister) {
                        utilsSnackbar(context, 'Utilisateur Crée.');
                        LoginScreen.navigateTo(context);
                      }
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  )
                      : const Text('Valider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
