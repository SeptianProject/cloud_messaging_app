// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fcm_app/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Spacer(),
            const Text(
              'Login With Email',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 97, 97, 97),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.indigoAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              onPressed: () async {
                try {
                  final email = _emailController.text.trim();
                  await supabase.auth.signInWithOtp(
                    email: email,
                    emailRedirectTo:
                        'io.supabase.flutterquickstart://login-callback/',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check your email for the OTP'),
                        backgroundColor: Colors.indigoAccent,
                      ),
                    );
                  }
                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('An error has occurred, please retry'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
