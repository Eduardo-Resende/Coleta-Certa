import 'dart:io';

import 'package:coleta_certa/ui/about_the_app_screen.dart';
import 'package:coleta_certa/ui/user_settings_screen.dart';
import 'package:coleta_certa/ux/Util.dart';
import 'package:coleta_certa/ux/app_theme.dart';
import 'package:coleta_certa/ux/cep.dart';
import 'package:coleta_certa/ux/config_item.dart';
import 'package:coleta_certa/ux/config_navegator.dart';
import 'package:coleta_certa/ux/floating_navigation_bar.dart';
import 'package:coleta_certa/ux/navigate_screen.dart';
import 'package:coleta_certa/ux/notificacoes.dart';
import 'package:coleta_certa/ux/show_profile_photo_dialog.dart';
import 'package:coleta_certa/ux/user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context).usuario;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 36, 139, 55),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: width,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(width, 40),
                        bottomRight: Radius.elliptical(width, 40),
                      ),
                      color: const Color.fromARGB(255, 36, 139, 55),
                    ),
                    child: const SizedBox(),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user?.photoPath != null) {
                              showProfilePhotoDialog(context, user!.photoPath!);
                            }
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            backgroundImage: user?.photoPath != null
                                ? FileImage(File(user!.photoPath!))
                                : null,
                            child: user?.photoPath == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        Text(
                          user!.name,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    ConfigItem(
                      icon: Icons.notifications_outlined,
                      text: 'Ativar Notificações',
                      onToggle: (isOn) async {
                        final user =
                            Provider.of<UserProvider>(context, listen: false)
                                .usuario;
                        if (user == null || user.bairro == null) return;

                        if (isOn) {
                          // 1) Tentar pedir permissão e, se negado, oferecer opção para tentar de novo
                          bool? granted = await NotificationService.instance
                              .requestPermission();

                          // Enquanto o usuário negar, perguntar se quer tentar novamente
                          while (granted != true) {
                            final retry = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Permissão de Notificações'),
                                content: const Text(
                                  'Você negou a permissão de notificações. '
                                  'Para receber alertas de coleta, precisamos dessa permissão. '
                                  'Deseja tentar novamente?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: const Text('Tentar Novamente'),
                                  ),
                                ],
                              ),
                            );

                            // Se o usuário escolher cancelar, sai do loop
                            if (retry != true) return;

                            // Tentar pedir permissão outra vez
                            granted = await NotificationService.instance
                                .requestPermission();
                          }

                          // 2) Agora que está garantido que granted == true, busca os horários
                          final horarios =
                              await NotificationService.getHorariosPorBairro(
                                  user.bairro!);

                          // 3) Para cada horário, calcula e agenda as notificações
                          for (var h in horarios) {
                            final horarioStr = h.horario.trim().toLowerCase();
                            int? horaColeta;
                            int minutoColeta = 0;

                            if (horarioStr == 'diurno') {
                              horaColeta = 8;
                            } else if (horarioStr == 'noturno') {
                              horaColeta = 18;
                            } else if (horarioStr.contains(':')) {
                              final partes = horarioStr.split(':');
                              if (partes.length != 2) {
                                debugPrint('Horário mal-formatado: "$horarioStr"');
                                continue;
                              }
                              final hInt = int.tryParse(partes[0]);
                              final mInt = int.tryParse(partes[1]);
                              if (hInt == null || mInt == null) {
                                debugPrint(
                                    'Não foi possível converter horário: "$horarioStr"');
                                continue;
                              }
                              horaColeta = hInt;
                              minutoColeta = mInt;
                            } else {
                              debugPrint('Horário inválido recebido: "$horarioStr"');
                              continue;
                            }

                            // Próxima data daquele dia da semana
                            DateTime agora = DateTime.now();
                            int diaSemanaNum =
                                Util.mapDiaParaWeekday(h.diaDaSemana);
                            int diasAte =
                                (diaSemanaNum - agora.weekday + 7) % 7;
                            if (diasAte == 0) diasAte = 7;

                            DateTime dataColeta =
                                agora.add(Duration(days: diasAte));

                            // 18h do dia anterior
                            DateTime diaAnterior =
                                dataColeta.subtract(const Duration(days: 1));
                            DateTime aviso1 = DateTime(
                              diaAnterior.year,
                              diaAnterior.month,
                              diaAnterior.day,
                              18,
                              0,
                            );
                            await NotificationService.instance.scheduleNotification(
                              id: h.idHorario * 10 + 1,
                              title: 'Coleta Amanhã',
                              body:
                                  'Amanhã tem coleta no seu bairro às ${_formatHorarioExibicao(h.horario)}',
                              scheduledDate: aviso1,
                            );

                            // Notificação no horário exato do dia da coleta
                            DateTime aviso2 = DateTime(
                              dataColeta.year,
                              dataColeta.month,
                              dataColeta.day,
                              horaColeta!,
                              minutoColeta,
                            );
                            await NotificationService.instance.scheduleNotification(
                              id: h.idHorario * 10 + 2,
                              title: 'Coleta Hoje',
                              body:
                                  'Coleta hoje às ${_formatHorarioExibicao(h.horario)}',
                              scheduledDate: aviso2,
                            );

                            // Se for “noturno” ou tipoColeta == “vespertino”, agenda lembrete ao meio-dia
                            if (horarioStr == 'noturno' ||
                                h.tipoColeta.toLowerCase() == 'vespertino') {
                              DateTime aviso3 = DateTime(
                                dataColeta.year,
                                dataColeta.month,
                                dataColeta.day,
                                12,
                                0,
                              );
                              await NotificationService.instance
                                  .scheduleNotification(
                                id: h.idHorario * 10 + 3,
                                title: 'Coleta Hoje',
                                body:
                                    'Coleta vespertina hoje às ${_formatHorarioExibicao(h.horario)}',
                                scheduledDate: aviso3,
                              );
                            }
                          }
                        } else {
                          // Desativa: cancela todas as notificações
                          await NotificationService.instance
                              .cancelAllNotifications();
                        }
                      },
                    ),
                    ConfigItem(
                      icon: Icons.dark_mode_outlined,
                      text: "Ativar Modo Escuro",
                      onToggle: (isOn) {
                        themeProvider.toggleTheme(isOn);
                      },
                    ),
                    ConfigItem(
                      icon: Icons.location_on_outlined,
                      text: 'Ativar Localização',
                      onToggle: (isOn) async {
                        final userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        final user = userProvider.usuario;

                        if (isOn) {
                          // Ativa e começa a puxar localização em tempo real
                          bool serviceEnabled =
                              await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            await Geolocator.openLocationSettings();
                            return;
                          }

                          LocationPermission permission =
                              await Geolocator.checkPermission();
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                            if (permission ==
                                    LocationPermission.deniedForever ||
                                permission == LocationPermission.denied) {
                              return;
                            }
                          }

                          Geolocator.getPositionStream().listen((
                            Position position,
                          ) {
                            if (user != null) {
                              userProvider.setUsuario(
                                User(
                                  name: user.name,
                                  cep: user.cep,
                                  bairro: user.bairro,
                                  latitude: position.latitude,
                                  longitude: position.longitude,
                                  photoPath: user.photoPath,
                                ),
                              );
                            }
                          });
                        } else {
                          // Desativa localização em tempo real e restaura via CEP
                          if (user != null) {
                            final cepService = Cep();
                            final data = await cepService.validaCep(user.cep);
                            if (data != null) {
                              userProvider.setUsuario(
                                User(
                                  name: user.name,
                                  cep: user.cep,
                                  bairro: data['bairro'],
                                  latitude: data['latitude'],
                                  longitude: data['longitude'],
                                  photoPath: user.photoPath,
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                    ConfigNavegator(
                      icon: Icons.edit_outlined,
                      text: "Editar Perfil",
                      onTap: () => NavigateScreen.changeScreen(
                        context,
                        UserSettingsScreen(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => NavigateScreen.changeScreen(
                            context,
                            AboutTheAppScreen(),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Sobre o APP',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const FloatingNavigationBar(),
      ],
    );
  }

  /// Formata a string de exibição do horário: “Diurno” mostra “08:00”,
  /// e “Noturno” mostra “18:00”. Se vier “HH:mm”, exibe como está.
  String _formatHorarioExibicao(String horarioOriginal) {
    final s = horarioOriginal.trim().toLowerCase();
    if (s == 'diurno') return '08:00';
    if (s == 'noturno') return '18:00';
    return horarioOriginal;
  }
}
