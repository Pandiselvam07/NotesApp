import 'package:flutter/material.dart';
import 'package:pratice/utilities/dialogs/Generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure you want delete?",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
    optionColors: () => {
      "Cancel": Colors.black,
      "Yes": Colors.red,
    },
  ).then(
    (value) => value ?? false,
  );
}
