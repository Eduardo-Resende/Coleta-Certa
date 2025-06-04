import 'package:coleta_certa/database/db.dart';
import 'package:coleta_certa/ui/horario_coleta_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService instance = NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  /// Solicita permissão de notificação no Android 13+.
  Future<bool?> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return androidImpl?.requestNotificationsPermission();
  }

  /// Agenda uma notificação pontual no horário exato (even allow while idle).
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'coleta_channel',
          'Coletas',
          channelDescription: 'Notificações de coleta',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // Parâmetro obrigatório na v19:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Para notificações pontuais:
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  /// Cancela todas as notificações agendadas.
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

    /// Busca todos os horários de coleta para o bairro X
  static Future<List<HorarioColeta>> getHorariosPorBairro(String nomeBairro) async {
    final database = await DB.instance.database;
    final List<Map<String, dynamic>> resultado = await database.rawQuery('''
      SELECT
        hc.idHorario,
        tc.tipoColeta,
        ds.diaDaSemana,
        hc.horario
      FROM horario_coleta AS hc
      JOIN bairro AS b       ON hc.idBairro = b.idBairro
      JOIN tipo_coleta AS tc ON hc.idTipoColeta = tc.idTipoColeta
      JOIN dia_semana AS ds  ON hc.idDia = ds.idDia
      WHERE b.nomeBairro = ?
    ''', [nomeBairro]);

    return resultado.map((row) {
      return HorarioColeta(
        idHorario: row['idHorario'] as int,
        tipoColeta: row['tipoColeta'] as String,
        diaDaSemana: row['diaDaSemana'] as String,
        horario: row['horario'] as String,
      );
    }).toList();
  }
}