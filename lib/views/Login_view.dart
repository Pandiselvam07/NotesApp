import 'package:flutter/material.dart';
import 'package:pratice/services/auth/Auth_exceptions.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/auth/bloc/Auth_state.dart';
import 'package:pratice/utilities/dialogs/Error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(context, "Invalid Credential");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid Email");
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(context, "Channel Error");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication Error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
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
                    hintText: "Enter your Email ID",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                autofocus: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 3),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(25))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(email, password),
                      );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.cyan),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventForgotPassword());
                      },
                      child: Text('Forgot Password')),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not registered yet ? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                        child: Text(
                          "Register here",
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ],
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
