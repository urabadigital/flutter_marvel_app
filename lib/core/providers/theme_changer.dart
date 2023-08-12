import 'package:flutter/material.dart';

class MyChangeNotifier extends ChangeNotifier {
  bool isWhite = true;

  void updateTheme() {
    isWhite = !isWhite;
    notifyListeners();
  }
}

class ThemeChanger extends InheritedWidget {
  const ThemeChanger({
    super.key,
    required super.child,
    required this.myChangeNotifier,
  });

  final MyChangeNotifier myChangeNotifier;

  static ThemeChanger of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<ThemeChanger>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
