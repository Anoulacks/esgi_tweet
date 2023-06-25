import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/utils/date_utils.dart';
import 'package:esgi_tweet/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool checkUpdate = false;

  final _profileForm = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _pseudoController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              _firstnameController.text = state.user?.firstname ?? '';
              _lastnameController.text = state.user?.lastname ?? '';
              _pseudoController.text = state.user?.pseudo ?? '';
              _birthDateController.text = timestampToString(state.user?.birthDate) ?? '';
              _phoneNumberController.text = state.user?.phoneNumber ?? '';
              _addressController.text = state.user?.address ?? '';
              _emailController.text = state.user?.email ?? '';
              return Form(
                key: _profileForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(child: Text('Z')),
                      ),
                    TextFormField(
                      controller: _lastnameController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                      ),
                    ),
                    TextFormField(
                      controller: _firstnameController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "Prénom",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champs Obligatoire';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _pseudoController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "Pseudo",
                      ),
                    ),
                    TextFormField(
                      controller: _birthDateController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "Date de Naissance",
                      ),
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "numéro de téléphone",
                      ),
                    ),
                    TextFormField(
                      controller: _addressController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "adresse",
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      enabled: checkUpdate,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    checkUpdate
                        ? BlocConsumer<UsersBloc, UsersState>(
                      listener: (context, state) {
                        switch (state.status) {
                          case UsersStatus.initial:
                            break;
                          case UsersStatus.loading:
                            _showSnackBar(context, 'Chargement');
                            break;
                          case UsersStatus.error:
                            _showSnackBar(context, state.error ?? '');
                            break;
                          case UsersStatus.success:
                            utilsSnackbar(context, 'Profil Modifié');
                            break;
                        }
                      },
                      builder: (context, state) {
                        return Builder(builder: (context) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_profileForm.currentState!.validate()) {
                                  final UserApp newUser = UserApp(
                                      id: state.user?.id,
                                      firstname: _firstnameController.text,
                                      lastname: _lastnameController.text,
                                      pseudo: _pseudoController.text,
                                      birthDate: Timestamp.fromDate(
                                          DateTime.parse(
                                              _birthDateController.text)),
                                      phoneNumber: _phoneNumberController.text,
                                      address: _addressController.text,
                                      photoURL: state.user?.photoURL,
                                      email: _emailController.text,
                                      followers: state.user?.followers,
                                      followings: state.user?.followings
                                  );

                                  BlocProvider.of<UsersBloc>(context).add(
                                      UpdateUser(newUser));
                                }
                              },
                              child: const Text(
                                  'Enregistrer les Modifications'),
                            ),
                          );
                        });
                      },
                    )
                        : const Text("")
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_enableUpdate()},
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _enableUpdate() {
    setState(() {
      checkUpdate = !checkUpdate;
    });
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
