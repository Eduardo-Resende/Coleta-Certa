// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:coleta_certa/ux/cep.dart';
import 'package:coleta_certa/ux/image_crop.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cepController = TextEditingController();
  final Cep _cepValidator = Cep();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).usuario;
    if (user != null) {
      _nameController.text = user.name;
      _cepController.text = user.cep;
      _photoPath = user.photoPath;
    }
  }

  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    final imageFile = File(pickedFile.path);

    // Navegação para a tela de recorte
    final croppedImagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropScreen(imageFile: imageFile),
      ),
    );

    if (croppedImagePath != null) {
      setState(() {
        _photoPath = croppedImagePath; // Atualiza o caminho da imagem recortada
      });
    }
  }
}

  Future<void> _saveUserChanges() async {
    if (_formKey.currentState!.validate()) {
      final result = await _cepValidator.validaCep(_cepController.text);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CEP inválido ou não encontrado'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final updatedUser = User(
        name: _nameController.text,
        cep: _cepController.text,
        bairro: result['bairro'],
        latitude: result['latitude'],
        longitude: result['longitude'],
        photoPath: _photoPath,
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUsuario(updatedUser);
      await userProvider.saveUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'nunito',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green.shade700,
                        backgroundImage:
                            _photoPath != null
                                ? FileImage(File(_photoPath!))
                                : null,
                        child:
                            _photoPath == null
                                ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: _pickImage,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe seu nome'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o CEP';
                  if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                    return 'CEP precisa ter 8 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Salvar alterações',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _saveUserChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
