import 'package:pratice/helper/loading/Loading_screen.dart';
import 'package:pratice/services/auth/Firebase_auth_provider.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/auth/bloc/Auth_state.dart';
import 'package:pratice/views/ForgotPassword_View.dart';
import 'package:pratice/views/Login_view.dart';
import 'package:pratice/views/Register_view.dart';
import 'package:pratice/views/VerifyEmail_view.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/views/notes/Notes_view.dart';
import 'package:pratice/views/notes/create _update_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? "Please wait a moment");
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        //Bloc
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotpasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
