import 'package:fcm_app/main.dart';
import 'package:fcm_app/pages/profile_page.dart';
import 'package:fcm_app/services/notification_service.dart';
import 'package:fcm_app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _future = supabase.from('countries').select();
  final NotificationService _notficationService = NotificationService();
  final _future = supabase.from('countries').select();

  @override
  void initState() {
    super.initState();
    _notficationService.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      bottomNavigationBar: BottomNavbar(
        onFirst: () {
          Navigator.pushNamed(context, '/home');
        },
        onSecond: () {
          Navigator.pushNamed(context, '/profile');
        },
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
