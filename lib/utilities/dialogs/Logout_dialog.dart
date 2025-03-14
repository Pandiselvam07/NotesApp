import 'package:flutter/material.dart';
import 'package:pratice/utilities/dialogs/Generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout",
    content: "Are you sure you want Logout?",
    optionsBuilder: () => {
      "Cancel": false,
      "Logout": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
