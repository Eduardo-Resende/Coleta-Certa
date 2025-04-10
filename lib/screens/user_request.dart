// ignore_for_file: use_build_context_synchronously

import 'package:coleta_certa/screens/home_screen.dart';
import 'package:coleta_certa/ui/navigate_screen.dart';
import 'package:coleta_certa/ui/user.dart';
import 'package:coleta_certa/ui/validate_cep.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRequest extends StatefulWidget {
  const UserRequest({super.key});

  @override
  State<UserRequest> createState() => _UserRequestState();
}

class _UserRequestState extends State<UserRequest> {
  @override
  Widget build(BuildContext context) {
    final NavigateScreen navigateScreen = NavigateScreen();
    final ValidateCep validateCep = ValidateCep();
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController cepController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/img/coleta_certa_sem_fundo.png'),
                TextFormField(
                  decoration: InputDecoration(label: Text("Nome")),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text("CEP")),
                  controller: cepController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o CEP';
                    } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                      return 'CEP precisa ter 8 caracteres';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: const Color.fromARGB(255, 36, 139, 55),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final valido = await validateCep.validaCep(
                          cepController.text,
                        );

                        if (!valido) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('CEP não encontrado'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        User user = User(
                          name: nameController.text,
                          cep: cepController.text,
                        );

                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).setUsuario(user);
                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).saveUser(user);
                        navigateScreen.changeScreen(context, HomeScreen());
                      }
                    },
                    child: Text("Entrar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
