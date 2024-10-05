import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_bloc.dart';
import 'package:pratice/services/auth/bloc/Auth_event.dart';
import 'package:pratice/services/auth/bloc/Auth_state.dart';
import 'package:pratice/utilities/dialogs/Error_dialog.dart';
import 'package:pratice/utilities/dialogs/Password_reset_dialog.dart';

class ForgotpasswordView extends StatefulWidget {
  const ForgotpasswordView({super.key});

  @override
  State<ForgotpasswordView> createState() => _ForgotpasswordViewState();
}

class _ForgotpasswordViewState extends State<ForgotpasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordRestSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                "We could not process your request , make sure you have entered valid email ");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              const Text(
                "If you forgot your password , Enter your registered email we will send you a password reset link",
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 3),
                        borderRadius: BorderRadius.circular(25)),
                    hintText: "Enter your Registered Email",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                        borderRadius: BorderRadius.circular(25))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.cyan),
                ),
                child: const Text(
                  "Send password reset link",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(
                  "Back to Login View",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
