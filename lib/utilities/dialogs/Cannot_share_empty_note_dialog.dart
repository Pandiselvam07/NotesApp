import 'package:pratice/utilities/dialogs/Generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareShareEmptyNote(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "Cannot share empty note",
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
