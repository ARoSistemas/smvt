import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';
import '../../providers/login/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  void goHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login with Provider')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintText: 'demo@arosistemas.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => loginProvider.email = value.trim(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        loginProvider.errorMessage =
                            'Por favor ingrese su email';
                        return loginProvider.errorMessage;
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        loginProvider.errorMessage =
                            'Por favor ingrese un email válido';
                        return loginProvider.errorMessage;
                      }

                      loginProvider.errorMessage = '';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      hintText: '123456',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onChanged: (value) => loginProvider.password = value.trim(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        loginProvider.errorMessage =
                            'Por favor ingrese su contraseña';
                        return loginProvider.errorMessage;
                      }
                      if (value.length < 6) {
                        loginProvider.errorMessage =
                            'La contraseña debe tener al menos 6 caracteres';
                        return loginProvider.errorMessage;
                      }

                      loginProvider.errorMessage = '';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: loginProvider.isLoading
                        ? null
                        : () {
                            _formKey.currentState!.validate();

                            if (loginProvider.errorMessage.isEmpty) {
                              loginProvider.login().then(
                                (_) {
                                  if (loginProvider.isSuccess) {
                                    goHomePage();
                                  } else {
                                    _showErrorSnackBar(
                                      loginProvider.errorMessage,
                                    );
                                  }
                                },
                              );
                            } else {
                              _showErrorSnackBar(
                                loginProvider.errorMessage,
                              );
                            }
                          },
                    child: loginProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Iniciar Sesión'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
