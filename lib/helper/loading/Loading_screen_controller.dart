import 'package:flutter/material.dart';

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingStringController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingStringController({
    required this.close,
    required this.update,
  });
}
