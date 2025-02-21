import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();
typedef DialogOptionColorBuilder = Map<String, Color?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder<T> optionsBuilder,
  DialogOptionColorBuilder? optionColors, // Optional color builder
}) {
  final options = optionsBuilder();
  final colors = optionColors != null ? optionColors() : {};

  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          final color = colors[optionTitle] ?? Colors.blue; // Default color

          return TextButton(
            onPressed: () {
              Navigator.of(context).pop(value);
            },
            child: Text(
              optionTitle,
              style: TextStyle(color: color), // Apply color
            ),
          );
        }).toList(),
      );
    },
  );
}
