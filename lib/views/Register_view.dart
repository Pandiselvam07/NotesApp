import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/services/auth/Auth_service.dart';
import 'dart:developer' as devtools show log;
import 'package:pratice/utilities/ShowErrorDialog.dart';
import 'package:pratice/services/auth/Auth_exceptions.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter your email id"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyemailroute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak Password");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email already in use");
              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Invalid Email");
              } on ChannelErrorAuthException {
                await showErrorDialog(context, "Channel Error");
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginroute, (route) => false);
            },
            child: const Text(
              "Already register ? Login here",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
