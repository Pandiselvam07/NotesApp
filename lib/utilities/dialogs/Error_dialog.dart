import 'package:flutter/material.dart';
import 'package:pratice/utilities/dialogs/Generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: "Error occurred",
    content: text,
    optionsBuilder: () => {'Ok': null},
  );
}
