import 'package:fcm_app/firebase_options.dart';
import 'package:fcm_app/pages/home_page.dart';
import 'package:fcm_app/pages/notification_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await Supabase.initialize(
  //   url: 'https://dftdyuehfbsambrhyzkn.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmdGR5dWVoZmJzYW1icmh5emtuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc0ODU3MjQsImV4cCI6MjA0MzA2MTcyNH0.a6iyd3fyi9FOyP9kjxVuXxA0V79okpJ4Kml97D5QLYU',
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Future.delayed(const Duration(seconds: 3)),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //           ),
    //         );
    //       } else {

    //       }
    //     });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: const HomePage(),
      navigatorKey: navigatorKey,
      routes: {
        '/home': (context) => const HomePage(),
        '/notification_screen': (context) => const NotificationPage(),
      },
    );
  }
}
