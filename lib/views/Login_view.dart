import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pratice/constants/Routes.dart';
import 'package:pratice/firebase_options.dart';
import 'package:pratice/views/Register_view.dart';
import 'dart:developer' as devtools show log;

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
                  final userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesroute, (route) => false);
                  devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == "invalid-credential") {
                    devtools.log('Invalid Credential');
                  } else if (e.code == "Wrong-Password") {
                    devtools.log('Wrong Password');
                  }
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
