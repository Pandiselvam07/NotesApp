import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/services/auth/Auth_service.dart';
import 'package:pratice/services/auth/Auth_exceptions.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/auth/bloc/Auth_state.dart';
import 'package:pratice/utilities/dialogs/Error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak Password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email already in use");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email");
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(context, "Channel Error");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                autocorrect: false,
                autofocus: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 3),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: "Enter you Email ID",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(25))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 3),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventRegister(email, password));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.cyan),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already register ? ",
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: Text(
                      "Login here",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
