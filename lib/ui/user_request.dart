// ignore_for_file: use_build_context_synchronously

import 'package:coleta_certa/ui/home_screen.dart';
import 'package:coleta_certa/ux/cep_formater.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:coleta_certa/ux/cep.dart';
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
    final Cep validateCep = Cep();
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
                  maxLength: 15,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 36, 139, 55),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o nome';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextFormField(
                    maxLength: 9,
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CepInputFormatter()],
                    decoration: InputDecoration(
                      labelText: "CEP",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 36, 139, 55),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o CEP';
                      } else if (!RegExp(r'^\d{5}-\d{3}$').hasMatch(value)) {
                        return 'Formato esperado: 00000-000';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: const Color.fromARGB(255, 36, 139, 55),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await validateCep.validaCep(
                          cepController.text,
                        );

                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('CEP inválido ou não encontrado'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        User user = User(
                          name: nameController.text,
                          cep: cepController.text,
                          bairro: result['bairro'],
                          latitude: result['latitude'],
                          longitude: result['longitude'],
                        );

                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).setUsuario(user);
                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).saveUser(user);
                        NavigateScreen.changeScreen(context, HomeScreen());
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
