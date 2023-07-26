import 'package:esgi_tweet/repositorys/users_repository.dart';
import 'package:esgi_tweet/screens/area/area_screen.dart';
import 'package:esgi_tweet/screens/authentification/register_screen.dart';
import 'package:esgi_tweet/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/Login';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _loginForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Adresse Mail'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_loginForm.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String email = _emailController.text;
                          String password = _passwordController.text;
                          bool checkConnexion =
                              await RepositoryProvider.of<UsersRepository>(
                                      context)
                                  .signIn(email, password, context);

                          setState(() {
                            _isLoading = false;
                          });

                          if (checkConnexion) {
                            AreaScreen.navigateTo(context);
                          }
                        } else {
                          utilsSnackbar(context, 'Format Invalide.');
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
                    : const Text('se connecter'),
              ),
              ElevatedButton(
                onPressed: () {
                  RegisterScreen.navigateTo(context);
                },
                child: const Text('s\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
