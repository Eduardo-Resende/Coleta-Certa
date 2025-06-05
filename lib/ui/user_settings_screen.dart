// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:coleta_certa/ux/Util.dart';
import 'package:coleta_certa/ux/cep.dart';
import 'package:coleta_certa/ux/cep_formater.dart';
import 'package:coleta_certa/ux/image_crop.dart';
import 'package:coleta_certa/ux/notificacoes.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

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
          _photoPath =
              croppedImagePath; // Atualiza o caminho da imagem recortada
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

      // 1) Cria o novo User com bairro atualizado
      final updatedUser = User(
        name: _nameController.text,
        cep: _cepController.text,
        bairro: result['bairro'],
        latitude: result['latitude'],
        longitude: result['longitude'],
        photoPath: _photoPath,
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // 2) Atualiza o provider e SharedPreferences
      userProvider.setUsuario(updatedUser);
      await userProvider.saveUser(updatedUser);

      // 3) Cancela todas as notificações agendadas para o bairro antigo
      await NotificationService.instance.cancelAllNotifications();

      // 4) Re-agenda notificações para o bairro novo
      final horarios =
          await NotificationService.getHorariosPorBairro(updatedUser.bairro!);
      for (var h in horarios) {
        final horarioStr = h.horario.trim().toLowerCase();

        // Se for "diurno" => 08:00, se for "noturno" => 18:00
        int? horaColeta;
        int minutoColeta = 0;

        if (horarioStr == 'Diurno') {
          horaColeta = 8;
        } else if (horarioStr == 'Noturno') {
          horaColeta = 18;
        } else if (horarioStr.contains(':')) {
          // Caso você queira ainda aceitar "HH:mm" para outros cenários
          final partes = horarioStr.split(':');
          if (partes.length != 2) {
            debugPrint('Horário mal-formatado: "$horarioStr"');
            continue;
          }
          final hInt = int.tryParse(partes[0]);
          final mInt = int.tryParse(partes[1]);
          if (hInt == null || mInt == null) {
            debugPrint('Não foi possível converter horário: "$horarioStr"');
            continue;
          }
          horaColeta = hInt;
          minutoColeta = mInt;
        } else {
          debugPrint('Horário inválido recebido: "$horarioStr"');
          continue;
        }

        // Calcula a próxima data de coleta baseada no dia da semana
        final agora = tz.TZDateTime.now(tz.local);
        final diaSemanaNum = Util.mapDiaParaWeekday(h.diaDaSemana);
        int diasAte = (diaSemanaNum - agora.weekday + 7) % 7;
        if (diasAte == 0) diasAte = 7; // próxima semana
        final dataColeta = agora.add(Duration(days: diasAte));

        // 4a) notificação 18h do dia anterior
        final diaAnterior = dataColeta.subtract(const Duration(days: 1));
        final aviso1 = tz.TZDateTime(
          tz.local,
          diaAnterior.year,
          diaAnterior.month,
          diaAnterior.day,
          18, // hora fixa 18:00 do dia anterior
          0, // minuto
        );
        await NotificationService.instance.scheduleNotification(
          id: h.idHorario * 10 + 1,
          title: 'Coleta Amanhã',
          body: 'Amanhã tem coleta no seu bairro às ${_formatHorarioExibicao(h.horario)}',
          scheduledDate: aviso1,
        );

        // 4b) notificação no horário exato do dia da coleta
        final aviso2 = tz.TZDateTime(
          tz.local,
          dataColeta.year,
          dataColeta.month,
          dataColeta.day,
          horaColeta, // hora definida
          minutoColeta, // minuto definido
        );
        await NotificationService.instance.scheduleNotification(
          id: h.idHorario * 10 + 2,
          title: 'Coleta Hoje',
          body: 'Coleta hoje às ${_formatHorarioExibicao(h.horario)}',
          scheduledDate: aviso2,
        );

        // 4c) se for coleta vespertina (noturno), agenda um lembrete ao meio-dia
        //    ou se você quiser manter lógica diferente para "vespertino" vs. "noturno",
        //    ajuste o if abaixo de acordo. 
        if (horarioStr == 'noturno' || h.tipoColeta.toLowerCase() == 'vespertino') {
          final aviso3 = tz.TZDateTime(
            tz.local,
            dataColeta.year,
            dataColeta.month,
            dataColeta.day,
            12, // hora fixa 12:00
            0, // minuto
          );
          await NotificationService.instance.scheduleNotification(
            id: h.idHorario * 10 + 3,
            title: 'Coleta Hoje',
            body: 'Coleta vespertina hoje às ${_formatHorarioExibicao(h.horario)}',
            scheduledDate: aviso3,
          );
        }
      }

      // 5) Feedback ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informações e notificações atualizadas com sucesso'),
        ),
      );
    }
  }

  /// Formata a string de exibição do horário: "Diurno" mostrará "08:00",
  /// e "Noturno" mostrará "18:00" para o usuário. Se vier "HH:mm", exibe como está.
  String _formatHorarioExibicao(String horarioOriginal) {
    final s = horarioOriginal.trim().toLowerCase();
    if (s == 'diurno') return '08:00';
    if (s == 'noturno') return '18:00';
    return horarioOriginal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Editar Perfil',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'nunito',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
          ),
        ),
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
                        backgroundColor: const Color.fromARGB(255, 36, 139, 55),
                        backgroundImage:
                            _photoPath != null ? FileImage(File(_photoPath!)) : null,
                        child: _photoPath == null
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
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Nome",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
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
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLength: 9,
                controller: _cepController,
                keyboardType: TextInputType.number,
                inputFormatters: [CepInputFormatter()],
                decoration: InputDecoration(
                  labelText: "CEP",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
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
                    return 'Preencha o CEP';
                  } else if (!RegExp(r'^\d{5}-\d{3}$').hasMatch(value)) {
                    return 'Formato esperado: 00000-000';
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
                  backgroundColor: const Color.fromARGB(255, 36, 139, 55),
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
