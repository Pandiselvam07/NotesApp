import 'package:flutter/material.dart';
import 'package:pratice/services/auth/Auth_service.dart';
import 'package:pratice/views/Login_view.dart';
import 'package:pratice/views/Register_view.dart';
import 'package:pratice/views/VerifyEmail_view.dart';
import 'dart:developer' as devtools show log;
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/views/notes/Notes_view.dart';
import 'package:pratice/views/notes/create _update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const Homepage(),
      routes: {
        loginroute: (context) => const LoginView(),
        registerroute: (context) => const RegisterView(),
        notesroute: (context) => const NotesView(),
        verifyemailroute: (context) => const VerifyEmailView(),
        createupdatenoteroute: (context) => const CreateUpdateNoteView(),
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
