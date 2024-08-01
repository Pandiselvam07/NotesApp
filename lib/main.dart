import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pratice/firebase_options.dart';
import 'package:pratice/main.dart';
import 'package:pratice/views/Login_view.dart';
import 'package:pratice/views/Register_view.dart';
import 'package:pratice/views/VerifyEmail_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const Homepage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView()
      },
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print("Email verified");
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
              return const Text("done");
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
