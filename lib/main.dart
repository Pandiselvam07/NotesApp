import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pratice/services/auth/Firebase_auth_provider.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/auth/bloc/Auth_state.dart';
import 'package:pratice/views/Login_view.dart';
import 'package:pratice/views/Register_view.dart';
import 'package:pratice/views/VerifyEmail_view.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/views/notes/Notes_view.dart';
import 'package:pratice/views/notes/create _update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
