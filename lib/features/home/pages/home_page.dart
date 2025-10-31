import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../core/notifications/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = NotificationService();
  String? token;
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo FCM Flutter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _service.showLocal(
                  title: 'Notificación local',
                  body: 'Hola desde Flutter 🚀',
                );
              },
              child: const Text('Mostrar notificación local'),
            ),
            const SizedBox(height: 16),
            Text(
              'Token FCM: ${token ?? "Cargando..."}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
