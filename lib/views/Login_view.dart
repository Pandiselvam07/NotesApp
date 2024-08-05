import 'package:flutter/material.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/services/auth/Auth_service.dart';
import 'package:pratice/utilities/ShowErrorDialog.dart';
import 'dart:developer' as devtools show log;
import 'package:pratice/services/auth/Auth_exceptions.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              decoration:
                  const InputDecoration(hintText: "Enter your email id"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration:
                  const InputDecoration(hintText: "Enter your password"),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .logIn(email: email, password: password);
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesroute, (route) => false);
                  } else {
                    Navigator.of(context).pushNamed(verifyemailroute);
                  }
                } on InvalidCredentialAuthException {
                  await showErrorDialog(context, "Invalid Credential");
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, "Invalid Email");
                } on ChannelErrorAuthException {
                  await showErrorDialog(context, "Channel Error");
                } on GenericAuthException {
                  await showErrorDialog(context, "Authentication Error");
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerroute, (route) => false);
              },
              child: const Text(
                "Not registered yet? Register here",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ));
  }
}
