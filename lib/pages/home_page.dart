import 'package:fcm_app/services/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notficationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notficationService.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Home Page'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          handleShowNotification();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void handleShowNotification() async {
    _notficationService.showFlutterNotification(
      title: 'Halo Brody',
      body: 'Assalamualaikum',
    );
  }
}
