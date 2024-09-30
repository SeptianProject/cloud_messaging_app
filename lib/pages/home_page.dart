import 'package:fcm_app/main.dart';
import 'package:fcm_app/services/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = supabase.from('countries').select();
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
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final countries = snapshot.data!;
            return Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: countries.length,
                  itemBuilder: ((context, index) {
                    final country = countries[index];
                    return ListTile(
                      title: Text(country['name']),
                    );
                  })),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleShowNotification();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void handleShowNotification() {
    _notficationService.showFlutterNotification(
      title: 'Halo Brody',
      body: 'Assalamualaikum',
    );
  }
}
