import 'package:flutter/material.dart';
import 'package:pratice/utilities/dialogs/Generic_dialog.dart';

Future<void> showPasswordRestSentDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content: "We have sent you password reset link , Please check your email",
    optionsBuilder: () => {
      "ok": null,
    },
  );
}
