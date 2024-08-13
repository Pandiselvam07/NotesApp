import 'package:flutter/material.dart';
import 'package:pratice/utilities/dialogs/Generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure you want delete?",
    optionsBuilder: () => {
      "cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
