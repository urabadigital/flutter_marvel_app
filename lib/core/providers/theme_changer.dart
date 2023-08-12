import 'package:flutter/material.dart';


class MyChangeNotifier extends ChangeNotifier {
  bool isWhite = false;

  void updateTheme() {
    isWhite = !isWhite;
    notifyListeners();
  }
}

class ThemeChanger extends InheritedWidget {
  const ThemeChanger({Key? key, required Widget child, required this.myChangeNotifier}) : super(child: child, key: key);

  final MyChangeNotifier myChangeNotifier;

  static ThemeChanger of(BuildContext context) => context.findAncestorWidgetOfExactType<ThemeChanger>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}