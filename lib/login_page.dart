import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSupscription;

  @override
  void initState() {
    super.initState();
    _authSupscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSupscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign Up Page"),
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                try{
                  final email = _emailController.text.trim();
                  await supabase.auth.signInWithOtp(email: email);

                  if(mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Check your email inbox")));
                  }

                } on AuthException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message),
                        backgroundColor: Theme.of(context).colorScheme.error,));

                } catch(error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error has occurred. Please try again"),
                      backgroundColor: Theme.of(context).colorScheme.error,));
                }
              },
              child: const Text("Sign Up"),
          ),



        ],

      ),
    );

  }
}

